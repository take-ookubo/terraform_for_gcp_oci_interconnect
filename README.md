# GCP - OCI マルチクラウド接続 (Partner Interconnect / FastConnect)

GCP Cloud Interconnect（Partner Interconnect）と OCI FastConnect を使用したマルチクラウド接続の Terraform 構成

## アーキテクチャ概要

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                                                                                 │
│  ┌─────────────────────────────┐         ┌─────────────────────────────┐        │
│  │      Google Cloud Platform  │         │  Oracle Cloud Infrastructure │       │
│  │                             │         │                             │        │
│  │  ┌───────────────────────┐  │         │  ┌───────────────────────┐  │        │
│  │  │         VPC           │  │         │  │         VCN           │  │        │
│  │  │                       │  │         │  │                       │  │        │
│  │  │  ┌─────────────────┐  │  │         │  │  ┌─────────────────┐  │  │        │
│  │  │  │    Subnet       │  │  │         │  │  │    Subnet       │  │  │        │
│  │  │  │  10.0.0.0/24    │  │  │         │  │  │  192.168.0.0/24 │  │  │        │
│  │  │  └─────────────────┘  │  │         │  │  └─────────────────┘  │  │        │
│  │  │                       │  │         │  │                       │  │        │
│  │  └───────────┬───────────┘  │         │  └───────────┬───────────┘  │        │
│  │              │              │         │              │              │        │
│  │  ┌───────────▼───────────┐  │         │  ┌───────────▼───────────┐  │        │
│  │  │    Cloud Router       │  │         │  │    Dynamic Routing    │  │        │
│  │  │    (BGP ASN: 16550)   │  │         │  │    Gateway (DRG)      │  │        │
│  │  └───────────┬───────────┘  │         │  └───────────┬───────────┘  │        │
│  │              │              │         │              │              │        │
│  │  ┌───────────▼───────────┐  │         │  ┌───────────▼───────────┐  │        │
│  │  │  VLAN Attachment      │  │         │  │   FastConnect         │  │        │
│  │  │  (Partner Interconnect)│ │         │  │   (BGP ASN: 16550)    │  │        │
│  │  └───────────┬───────────┘  │         │  └───────────┬───────────┘  │        │
│  │              │              │         │              │              │        │
│  └──────────────┼──────────────┘         └──────────────┼──────────────┘        │
│                 │                                       │                       │
│                 │         ┌─────────────────────┐       │                       │
│                 │         │                     │       │                       │
│                 └────────►│  Partner Provider   │◄──────┘                       │
│                           │  (Equinix/Megaport) │                               │
│                           │                     │                               │
│                           └─────────────────────┘                               │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

## コンポーネント詳細

### GCP 側

| コンポーネント | 説明 |
|--------------|------|
| **VPC** | GCP のプライベートネットワーク |
| **Cloud Router** | BGP を使用した動的ルーティング |
| **VLAN Attachment** | Partner Interconnect 用の論理接続 |
| **Partner Interconnect** | パートナー経由の専用線接続（50Mbps〜50Gbps） |

### OCI 側

| コンポーネント | 説明 |
|--------------|------|
| **VCN** | OCI のプライベートネットワーク |
| **DRG (Dynamic Routing Gateway)** | VCN 外部への接続ゲートウェイ |
| **Virtual Circuit** | FastConnect の論理接続 |
| **FastConnect** | 専用線接続（1Gbps〜100Gbps） |

### パートナープロバイダー

GCP と OCI の両方に対応している主なパートナー:

- **Equinix Fabric**
- **Megaport**
- **Console Connect (PCCW)**

## 接続フロー

```
1. GCP VPC ─────► Cloud Router ─────► VLAN Attachment
                                            │
                                            ▼
                                    Partner Provider
                                            │
                                            ▼
   OCI VCN ◄───── DRG ◄───── Virtual Circuit
```

## BGP 設定

| 項目 | GCP | OCI |
|------|-----|-----|
| ASN | 16550 (GCP デフォルト) | 31898 (OCI デフォルト) |
| BGP セッション | Cloud Router で設定 | Virtual Circuit で設定 |

## ネットワーク設計例

| GCP CIDR | OCI CIDR |
|----------|----------|
| 10.0.0.0/24 | 192.168.0.0/24 |

## 前提条件

- GCP プロジェクト（課金有効）
- OCI テナンシー
- パートナープロバイダーとの契約
- Terraform >= 1.0

## ファイル構成

```
.
├── README.md
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
├── modules/
│   ├── gcp/
│   │   ├── vpc.tf
│   │   ├── cloud_router.tf
│   │   └── interconnect.tf
│   └── oci/
│       ├── vcn.tf
│       ├── drg.tf
│       └── fastconnect.tf
```

## 使用方法（2段階デプロイ）

GCP と OCI の接続には、GCP 側で生成されるペアリングキーを OCI 側に設定する必要があるため、Terraform を2段階で実行します。

### 第1段階：GCP リソースの作成

```bash
# 初期化
terraform init

# terraform.tfvars を作成（gcp_pairing_key は空のまま）
cp terraform.tfvars.example terraform.tfvars
# 各自の環境に合わせて値を編集

# プラン確認
terraform plan

# 適用（GCP リソース + OCI の VCN/DRG が作成される）
terraform apply
```

この段階で以下が作成されます：
- GCP: VPC、サブネット、Cloud Router、Partner Interconnect (VLAN Attachment)
- OCI: VCN、サブネット、DRG、DRG Attachment
- OCI Virtual Circuit は**まだ作成されません**

### 第2段階：OCI Virtual Circuit の作成

```bash
# ペアリングキーを取得
terraform output gcp_interconnect_attachment_pairing_key

# terraform.tfvars にペアリングキーを追加
# gcp_pairing_key = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/asia-northeast1/2"

# 再度適用（OCI Virtual Circuit が作成される）
terraform apply
```

### リソースの削除

```bash
terraform destroy
```

## 注意事項

1. **冗長性**: 本番環境では複数の接続を推奨（別のエッジロケーション）
2. **帯域幅**: GCP/OCI 両方で同じ帯域幅を選択
3. **リージョン**: 物理的に近いリージョンを選択し、レイテンシを最小化
4. **コスト**: Partner Interconnect と FastConnect の両方で月額費用が発生

## 参考リンク

- [GCP Partner Interconnect](https://cloud.google.com/network-connectivity/docs/interconnect/concepts/partner-overview)
- [OCI FastConnect](https://docs.oracle.com/en-us/iaas/Content/Network/Concepts/fastconnect.htm)