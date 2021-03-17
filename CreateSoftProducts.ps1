$moduleName = "HedinScriptModule"
$catalogmoduleName = "SoftProductsScriptModule"
$userName = 'sitecore\admin'
$idPassword = "Password12345"
$identityAlias = "id.hedin.localhost"
$authoringAlias = "authoring.hedin.localhost"

$typeOfGood = "Service"
$catalog = "SoftProducts"
$category1 = "ServicesProducts"
$category1DisplayName = "Services"
$category2 = "HedinTyreServices"
$category2DisplayName = "Wheels and Tyres"

Import-Module (Join-Path $PSScriptRoot "$moduleName") -DisableNameChecking
Import-Module (Join-Path $PSScriptRoot "$catalogmoduleName") -Force

$token = Get-Token -UserName $userName -Password $idPassword -IdentityServiceUri "https://$identityAlias"

CreateSoftProductCatalog -Token $token -Data @{Catalog=$catalog} -IdentityServiceUri "https://$authoringAlias"
CreateSoftProductCategoryFromCatalog -Token $token -Data @{Catalog=$catalog; Name=$category1; DisplayName=$category1DisplayName} -IdentityServiceUri "https://$authoringAlias"
CreateSoftProductCategoryFromCategory -Token $token -Data @{Catalog=$catalog; Name=$category2; DisplayName=$category2DisplayName; Parent=$category1} -IdentityServiceUri "https://$authoringAlias"
CreateSellableItem -Token $token -IdentityServiceUri "https://$authoringAlias" -Data @{Catalog=$catalog; Parent=$category2; ProductId="hjul_motering_falg_id"; Name="WheelMounting"; DisplayName="Montering lösa däck på fälg"; Description="Välj denna tjänst om montering av lösa däck på fälg"; TypeOfGood=$typeOfGood; Variants=@(`
        [pscustomobject]@{VariantId="priceCat2"; Name="TyreMounting12"; DisplayName="1.2 Däck - Montering och balansering + Hjulskifte";Price=950},`
        [pscustomobject]@{VariantId="priceCat1"; Name="TyreMounting34"; DisplayName="3.4 Däck - Montering och balansering + Hjulskifte";Price=1450})}
CreateSellableItem -Token $token -IdentityServiceUri "https://$authoringAlias" -Data @{Catalog=$catalog; Parent=$category2; ProductId="hjulskifte_id"; Name="WheelChange"; DisplayName="Hjulskifte utan däckhotell"; Description="Välj denna tjänst om du vill skifta hjul men inte har dem på något av våra däckhotell"; TypeOfGood=$typeOfGood; Variants=@(`
        [pscustomobject]@{VariantId="priceCat2"; Name="WheelChange12"; DisplayName="1.2 Hjul - Hjulskifte";Price=300},`
        [pscustomobject]@{VariantId="priceCat1"; Name="WheelChange34"; DisplayName="3.4 Hjul - Hjulskifte";Price=450})}
CreateSellableItem -Token $token -IdentityServiceUri "https://$authoringAlias" -Data @{Catalog=$catalog; Parent=$category2; ProductId="id_dackhotell_guld"; Name="WheelHotelGold"; DisplayName="Wheel Hotel Gold"; Description="Wheel Hotel Gold"; TypeOfGood=$typeOfGood; Variants=@(`
        [pscustomobject]@{VariantId="priceCat3"; Name="WheelChange14GoldSweden"; DisplayName="1.4 Hjul - Hjulskifte + Däckhotell Guld";Price=2595},`
        [pscustomobject]@{VariantId="priceCat2"; Name="WheelChange14GoldGöteborg"; DisplayName="1.4 Hjul - Hjulskifte + Däckhotell Guld Göteborg";Price=2795},`
        [pscustomobject]@{VariantId="priceCat1"; Name="WheelChange14GoldStockholm"; DisplayName="1.4 Hjul - Hjulskifte + Däckhotell Guld Stockholm";Price=3095})}
CreateSellableItem -Token $token -IdentityServiceUri "https://$authoringAlias" -Data @{Catalog=$catalog; Parent=$category2; ProductId="id_montering_balansering_guld"; Name="TyreHotelGold"; DisplayName="Tyre Hotel Gold"; Description="Tyre Hotel Gold"; TypeOfGood=$typeOfGood; Variants=@(`
        [pscustomobject]@{VariantId="priceCat3"; Name="TyreMounting14GoldSweden"; DisplayName="1.4 Däck - Montering och Balancering + Hjulskifte + Däckhotell Guld";Price=3095},`
        [pscustomobject]@{VariantId="priceCat2"; Name="TyreMounting14GoldGöteborg"; DisplayName="1.4 Däck - Montering och Balancering + Hjulskifte + Däckhotell Guld Göteborg";Price=3295},`
        [pscustomobject]@{VariantId="priceCat1"; Name="TyreMounting14GoldStockholm"; DisplayName="1.4 Däck - Montering och Balancering + Hjulskifte + Däckhotell Guld Stockholm";Price=3595})}
CreateSellableItem -Token $token -IdentityServiceUri "https://$authoringAlias" -Data @{Catalog=$catalog; Parent=$category2; ProductId="id_dackhotell_silver"; Name="WheelHotelSilver"; DisplayName="Wheel Hotel Silver"; Description="Wheel Hotel Silver"; TypeOfGood=$typeOfGood; Variants=@(`
        [pscustomobject]@{VariantId="priceCat3"; Name="WheelChange14SilverSweden"; DisplayName="1.4 Hjul - Hjulskifte + Däckhotell Silver";Price=1495},`
        [pscustomobject]@{VariantId="priceCat2"; Name="WheelChange14SilverGöteborg"; DisplayName="1.4 Hjul - Hjulskifte + Däckhotell Silver Göteborg";Price=1695},`
        [pscustomobject]@{VariantId="priceCat1"; Name="WheelChange14SilverStockholm"; DisplayName="1.4 Hjul - Hjulskifte + Däckhotell Silver Stockholm";Price=1995})}
CreateSellableItem -Token $token -IdentityServiceUri "https://$authoringAlias" -Data @{Catalog=$catalog; Parent=$category2; ProductId="id_montering_balansering_silver"; Name="TyreHotelSilver"; DisplayName="Tyre Hotel Silver"; Description="Tyre Hotel Silver"; TypeOfGood=$typeOfGood; Variants=@(`
        [pscustomobject]@{VariantId="priceCat3"; Name="TyreMounting14SilverSweden"; DisplayName="1.4 Däck - Montering och Balancering + Hjulskifte + Däckhotell Silver";Price=2495},`
        [pscustomobject]@{VariantId="priceCat2"; Name="TyreMounting14SilverGöteborg"; DisplayName="1.4 Däck - Montering och Balancering + Hjulskifte + Däckhotell Silver Göteborg";Price=2695},`
        [pscustomobject]@{VariantId="priceCat1"; Name="TyreMounting14SilverStockholm"; DisplayName="1.4 Däck - Montering och Balancering + Hjulskifte + Däckhotell Silver Stockholm";Price=2995})}
CreateSellableItem -Token $token -IdentityServiceUri "https://$authoringAlias" -Data @{Catalog=$catalog; Parent=$category2; ProductId="id_dackhotell"; Name="WheelHotelBronze"; DisplayName="Wheel Hotel Bronze"; Description="Wheel Hotel Bronze"; TypeOfGood=$typeOfGood; Variants=@(`
        [pscustomobject]@{VariantId="priceCat3"; Name="WheelChange14BronzeSweden"; DisplayName="1.4 Hjul - Hjulskifte + Däckhotell Bronze";Price=995},`
        [pscustomobject]@{VariantId="priceCat2"; Name="WheelChange14BronzeGöteborg"; DisplayName="1.4 Hjul - Hjulskifte + Däckhotell Bronze Göteborg";Price=1195},`
        [pscustomobject]@{VariantId="priceCat1"; Name="WheelChange14BronzeStockholm"; DisplayName="1.4 Hjul - Hjulskifte + Däckhotell Bronze Stockholm";Price=1495})}
CreateSellableItem -Token $token -IdentityServiceUri "https://$authoringAlias" -Data @{Catalog=$catalog; Parent=$category2; ProductId="id_montering_balansering_brons"; Name="TyreHotelBronze"; DisplayName="Tyre Hotel Bronze"; Description="Tyre Hotel Bronze"; TypeOfGood=$typeOfGood; Variants=@(`
        [pscustomobject]@{VariantId="priceCat3"; Name="TyreMounting14BronzeSweden"; DisplayName="1.4 Däck - Montering och Balancering + Hjulskifte + Däckhotell Bronze";Price=1995},`
        [pscustomobject]@{VariantId="priceCat2"; Name="TyreMounting14BronzeGöteborg"; DisplayName="1.4 Däck - Montering och Balancering + Hjulskifte + Däckhotell Bronze Göteborg";Price=2195},`
        [pscustomobject]@{VariantId="priceCat1"; Name="TyreMounting14BronzeStockholm"; DisplayName="1.4 Däck - Montering och Balancering + Hjulskifte + Däckhotell Bronze Stockholm";Price=2495})}
CreateSellableItem -Token $token -IdentityServiceUri "https://$authoringAlias" -Data @{Catalog=$catalog; Parent=$category2; ProductId="hjulbalansering_id"; Name="HjulBalansering"; DisplayName="Hjul Balansering"; Description="Hjul Balansering"; TypeOfGood=$typeOfGood; Variants=@(`
        [pscustomobject]@{VariantId="priceCat1"; Name="Hjulbalansering1"; DisplayName="Hjulbalansering";Price=0})}

Exit 1

$InventoryName = "SoftProduct_InventorySet"
CreateInventorySet -Token $token -Data @{Name="$InventoryName"; DisplayName="SoftProduct Inventory Set"} -IdentityServiceUri "https://$authoringAlias"
CreateAssociateCatalog -Token $token -Data @{InventoryName="$InventoryName"; CatalogName=$catalog} -IdentityServiceUri "https://$authoringAlias"
CreateAssociateSellableItem -Token $token -Data @{InventoryName="$InventoryName"; ProductId="HB"; VariantId="HB1"; Quantity=1000000} -IdentityServiceUri "https://$authoringAlias"
Exit 1

CreateAssociateSellableItem -Token $token -Data @{InventoryName="$InventoryName"; ProductId="hjul_motering_falg_id"; VariantId="WM1"; Quantity=1000000} -IdentityServiceUri "https://$authoringAlias"
CreateAssociateSellableItem -Token $token -Data @{InventoryName="$InventoryName"; ProductId="hjul_motering_falg_id"; VariantId="WM2"; Quantity=1000000} -IdentityServiceUri "https://$authoringAlias"
CreateAssociateSellableItem -Token $token -Data @{InventoryName="$InventoryName"; ProductId="hjulskifte_id"; VariantId="WC1"; Quantity=1000000} -IdentityServiceUri "https://$authoringAlias"
CreateAssociateSellableItem -Token $token -Data @{InventoryName="$InventoryName"; ProductId="hjulskifte_id"; VariantId="WC2"; Quantity=1000000} -IdentityServiceUri "https://$authoringAlias"
CreateAssociateSellableItem -Token $token -Data @{InventoryName="$InventoryName"; ProductId="id-dackhotell-guld"; VariantId="priceCat1"; Quantity=1000000} -IdentityServiceUri "https://$authoringAlias"
CreateAssociateSellableItem -Token $token -Data @{InventoryName="$InventoryName"; ProductId="id-dackhotell-guld"; VariantId="priceCat2"; Quantity=1000000} -IdentityServiceUri "https://$authoringAlias"
CreateAssociateSellableItem -Token $token -Data @{InventoryName="$InventoryName"; ProductId="id-dackhotell-guld"; VariantId="priceCat3"; Quantity=1000000} -IdentityServiceUri "https://$authoringAlias"
CreateAssociateSellableItem -Token $token -Data @{InventoryName="$InventoryName"; ProductId="id_tyrehotel_tyre_gold"; VariantId="priceCat1"; Quantity=1000000} -IdentityServiceUri "https://$authoringAlias"
CreateAssociateSellableItem -Token $token -Data @{InventoryName="$InventoryName"; ProductId="id_tyrehotel_tyre_gold"; VariantId="priceCat2"; Quantity=1000000} -IdentityServiceUri "https://$authoringAlias"
CreateAssociateSellableItem -Token $token -Data @{InventoryName="$InventoryName"; ProductId="id_tyrehotel_tyre_gold"; VariantId="priceCat3"; Quantity=1000000} -IdentityServiceUri "https://$authoringAlias"
CreateAssociateSellableItem -Token $token -Data @{InventoryName="$InventoryName"; ProductId="id-dackhotell-silver"; VariantId="priceCat1"; Quantity=1000000} -IdentityServiceUri "https://$authoringAlias"
CreateAssociateSellableItem -Token $token -Data @{InventoryName="$InventoryName"; ProductId="id-dackhotell-silver"; VariantId="priceCat2"; Quantity=1000000} -IdentityServiceUri "https://$authoringAlias"
CreateAssociateSellableItem -Token $token -Data @{InventoryName="$InventoryName"; ProductId="id-dackhotell-silver"; VariantId="priceCat3"; Quantity=1000000} -IdentityServiceUri "https://$authoringAlias"
CreateAssociateSellableItem -Token $token -Data @{InventoryName="$InventoryName"; ProductId="id_tyrehotel_tyre_silver"; VariantId="priceCat1"; Quantity=1000000} -IdentityServiceUri "https://$authoringAlias"
CreateAssociateSellableItem -Token $token -Data @{InventoryName="$InventoryName"; ProductId="id_tyrehotel_tyre_silver"; VariantId="priceCat2"; Quantity=1000000} -IdentityServiceUri "https://$authoringAlias"
CreateAssociateSellableItem -Token $token -Data @{InventoryName="$InventoryName"; ProductId="id_tyrehotel_tyre_silver"; VariantId="priceCat3"; Quantity=1000000} -IdentityServiceUri "https://$authoringAlias"
CreateAssociateSellableItem -Token $token -Data @{InventoryName="$InventoryName"; ProductId="id-dackhotell"; VariantId="priceCat1"; Quantity=1000000} -IdentityServiceUri "https://$authoringAlias"
CreateAssociateSellableItem -Token $token -Data @{InventoryName="$InventoryName"; ProductId="id-dackhotell"; VariantId="priceCat2"; Quantity=1000000} -IdentityServiceUri "https://$authoringAlias"
CreateAssociateSellableItem -Token $token -Data @{InventoryName="$InventoryName"; ProductId="id-dackhotell"; VariantId="priceCat3"; Quantity=1000000} -IdentityServiceUri "https://$authoringAlias"
CreateAssociateSellableItem -Token $token -Data @{InventoryName="$InventoryName"; ProductId="id_tyrehotel_tyre_bronze"; VariantId="priceCat1"; Quantity=1000000} -IdentityServiceUri "https://$authoringAlias"
CreateAssociateSellableItem -Token $token -Data @{InventoryName="$InventoryName"; ProductId="id_tyrehotel_tyre_bronze"; VariantId="priceCat2"; Quantity=1000000} -IdentityServiceUri "https://$authoringAlias"
CreateAssociateSellableItem -Token $token -Data @{InventoryName="$InventoryName"; ProductId="id_tyrehotel_tyre_bronze"; VariantId="priceCat3"; Quantity=1000000} -IdentityServiceUri "https://$authoringAlias"
