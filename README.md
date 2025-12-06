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

## 使用方法

```bash
# 初期化
terraform init

# プラン確認
terraform plan

# 適用
terraform apply
```

## 注意事項

1. **冗長性**: 本番環境では複数の接続を推奨（別のエッジロケーション）
2. **帯域幅**: GCP/OCI 両方で同じ帯域幅を選択
3. **リージョン**: 物理的に近いリージョンを選択し、レイテンシを最小化
4. **コスト**: Partner Interconnect と FastConnect の両方で月額費用が発生

## 参考リンク

- [GCP Partner Interconnect](https://cloud.google.com/network-connectivity/docs/interconnect/concepts/partner-overview)
- [OCI FastConnect](https://docs.oracle.com/en-us/iaas/Content/Network/Concepts/fastconnect.htm)
- [Equinix Fabric](https://www.equinix.com/interconnection-services/equinix-fabric)
