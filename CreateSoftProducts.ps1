param ($action)

$doCreateSoftProducts = $action -eq "CreateSoftProducts"
$doCreateInventory = $action -eq "CreateInventory"


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

DeleteSellableItem -Token $token -IdentityServiceUri "https://$authoringAlias" -CategoryId "$catalog-$category2" -SellableItem "id_dackhotell_guld"
DeleteSellableItem -Token $token -IdentityServiceUri "https://$authoringAlias" -CategoryId "$catalog-$category2" -SellableItem "id_dackhotell_silver"
DeleteSellableItem -Token $token -IdentityServiceUri "https://$authoringAlias" -CategoryId "$catalog-$category2" -SellableItem "id_dackhotell_brons"
DeleteSellableItem -Token $token -IdentityServiceUri "https://$authoringAlias" -CategoryId "$catalog-$category2" -SellableItem "hjul_motering_falg_id"
DeleteSellableItem -Token $token -IdentityServiceUri "https://$authoringAlias" -CategoryId "$catalog-$category2" -SellableItem "hjulskifte_id"
DeleteSellableItem -Token $token -IdentityServiceUri "https://$authoringAlias" -CategoryId "$catalog-$category2" -SellableItem "id_montering_balansering_guld"
DeleteSellableItem -Token $token -IdentityServiceUri "https://$authoringAlias" -CategoryId "$catalog-$category2" -SellableItem "id_montering_balansering_silver"
DeleteSellableItem -Token $token -IdentityServiceUri "https://$authoringAlias" -CategoryId "$catalog-$category2" -SellableItem "id_montering_balansering_brons"
DeleteSellableItem -Token $token -IdentityServiceUri "https://$authoringAlias" -CategoryId "$catalog-$category2" -SellableItem "hjulbalansering_id"

if ($doCreateSoftProducts) {
CreateSellableItem -Token $token -IdentityServiceUri "https://$authoringAlias" -Data @{Catalog=$catalog; Parent=$category2; ProductId="WHMORI"; Name="WheelMounting"; DisplayName="Montering lösa däck på fälg"; Description="Välj denna tjänst om montering av lösa däck på fälg"; TypeOfGood=$typeOfGood; Variants=@(`
        [pscustomobject]@{VariantId="P002"; Name="TyreMounting12"; DisplayName="1.2 Däck - Montering och balansering + Hjulskifte";Price=950},`
        [pscustomobject]@{VariantId="P001"; Name="TyreMounting34"; DisplayName="3.4 Däck - Montering och balansering + Hjulskifte";Price=1450})}
CreateSellableItem -Token $token -IdentityServiceUri "https://$authoringAlias" -Data @{Catalog=$catalog; Parent=$category2; ProductId="WHCH"; Name="WheelChange"; DisplayName="Hjulskifte utan däckhotell"; Description="Välj denna tjänst om du vill skifta hjul men inte har dem på något av våra däckhotell"; TypeOfGood=$typeOfGood; Variants=@(`
        [pscustomobject]@{VariantId="P002"; Name="WheelChange12"; DisplayName="1.2 Hjul - Hjulskifte";Price=300},`
        [pscustomobject]@{VariantId="P001"; Name="WheelChange34"; DisplayName="3.4 Hjul - Hjulskifte";Price=450})}
CreateSellableItem -Token $token -IdentityServiceUri "https://$authoringAlias" -Data @{Catalog=$catalog; Parent=$category2; ProductId="TYHOGO"; Name="WheelHotelGold"; DisplayName="Wheel Hotel Gold"; Description="Wheel Hotel Gold"; TypeOfGood=$typeOfGood; Variants=@(`
        [pscustomobject]@{VariantId="P003"; Name="WheelChange14GoldSweden"; DisplayName="1.4 Hjul - Hjulskifte + Däckhotell Guld";Price=2595},`
        [pscustomobject]@{VariantId="P002"; Name="WheelChange14GoldGöteborg"; DisplayName="1.4 Hjul - Hjulskifte + Däckhotell Guld Göteborg";Price=2795},`
        [pscustomobject]@{VariantId="P001"; Name="WheelChange14GoldStockholm"; DisplayName="1.4 Hjul - Hjulskifte + Däckhotell Guld Stockholm";Price=3095})}
CreateSellableItem -Token $token -IdentityServiceUri "https://$authoringAlias" -Data @{Catalog=$catalog; Parent=$category2; ProductId="TYHOTYGO"; Name="TyreHotelGold"; DisplayName="Tyre Hotel Gold"; Description="Tyre Hotel Gold"; TypeOfGood=$typeOfGood; Variants=@(`
        [pscustomobject]@{VariantId="P003"; Name="TyreMounting14GoldSweden"; DisplayName="1.4 Däck - Montering och Balancering + Hjulskifte + Däckhotell Guld";Price=3095},`
        [pscustomobject]@{VariantId="P002"; Name="TyreMounting14GoldGöteborg"; DisplayName="1.4 Däck - Montering och Balancering + Hjulskifte + Däckhotell Guld Göteborg";Price=3295},`
        [pscustomobject]@{VariantId="P001"; Name="TyreMounting14GoldStockholm"; DisplayName="1.4 Däck - Montering och Balancering + Hjulskifte + Däckhotell Guld Stockholm";Price=3595})}
CreateSellableItem -Token $token -IdentityServiceUri "https://$authoringAlias" -Data @{Catalog=$catalog; Parent=$category2; ProductId="TYHOSI"; Name="WheelHotelSilver"; DisplayName="Wheel Hotel Silver"; Description="Wheel Hotel Silver"; TypeOfGood=$typeOfGood; Variants=@(`
        [pscustomobject]@{VariantId="P003"; Name="WheelChange14SilverSweden"; DisplayName="1.4 Hjul - Hjulskifte + Däckhotell Silver";Price=1495},`
        [pscustomobject]@{VariantId="P002"; Name="WheelChange14SilverGöteborg"; DisplayName="1.4 Hjul - Hjulskifte + Däckhotell Silver Göteborg";Price=1695},`
        [pscustomobject]@{VariantId="P001"; Name="WheelChange14SilverStockholm"; DisplayName="1.4 Hjul - Hjulskifte + Däckhotell Silver Stockholm";Price=1995})}
CreateSellableItem -Token $token -IdentityServiceUri "https://$authoringAlias" -Data @{Catalog=$catalog; Parent=$category2; ProductId="TYHOTYSI"; Name="TyreHotelSilver"; DisplayName="Tyre Hotel Silver"; Description="Tyre Hotel Silver"; TypeOfGood=$typeOfGood; Variants=@(`
        [pscustomobject]@{VariantId="P003"; Name="TyreMounting14SilverSweden"; DisplayName="1.4 Däck - Montering och Balancering + Hjulskifte + Däckhotell Silver";Price=2495},`
        [pscustomobject]@{VariantId="P002"; Name="TyreMounting14SilverGöteborg"; DisplayName="1.4 Däck - Montering och Balancering + Hjulskifte + Däckhotell Silver Göteborg";Price=2695},`
        [pscustomobject]@{VariantId="P001"; Name="TyreMounting14SilverStockholm"; DisplayName="1.4 Däck - Montering och Balancering + Hjulskifte + Däckhotell Silver Stockholm";Price=2995})}
CreateSellableItem -Token $token -IdentityServiceUri "https://$authoringAlias" -Data @{Catalog=$catalog; Parent=$category2; ProductId="TYHOBR"; Name="WheelHotelBronze"; DisplayName="Wheel Hotel Bronze"; Description="Wheel Hotel Bronze"; TypeOfGood=$typeOfGood; Variants=@(`
        [pscustomobject]@{VariantId="P003"; Name="WheelChange14BronzeSweden"; DisplayName="1.4 Hjul - Hjulskifte + Däckhotell Bronze";Price=995},`
        [pscustomobject]@{VariantId="P002"; Name="WheelChange14BronzeGöteborg"; DisplayName="1.4 Hjul - Hjulskifte + Däckhotell Bronze Göteborg";Price=1195},`
        [pscustomobject]@{VariantId="P001"; Name="WheelChange14BronzeStockholm"; DisplayName="1.4 Hjul - Hjulskifte + Däckhotell Bronze Stockholm";Price=1495})}
CreateSellableItem -Token $token -IdentityServiceUri "https://$authoringAlias" -Data @{Catalog=$catalog; Parent=$category2; ProductId="TYHOTYBR"; Name="TyreHotelBronze"; DisplayName="Tyre Hotel Bronze"; Description="Tyre Hotel Bronze"; TypeOfGood=$typeOfGood; Variants=@(`
        [pscustomobject]@{VariantId="P003"; Name="TyreMounting14BronzeSweden"; DisplayName="1.4 Däck - Montering och Balancering + Hjulskifte + Däckhotell Bronze";Price=1995},`
        [pscustomobject]@{VariantId="P002"; Name="TyreMounting14BronzeGöteborg"; DisplayName="1.4 Däck - Montering och Balancering + Hjulskifte + Däckhotell Bronze Göteborg";Price=2195},`
        [pscustomobject]@{VariantId="P001"; Name="TyreMounting14BronzeStockholm"; DisplayName="1.4 Däck - Montering och Balancering + Hjulskifte + Däckhotell Bronze Stockholm";Price=2495})}
CreateSellableItem -Token $token -IdentityServiceUri "https://$authoringAlias" -Data @{Catalog=$catalog; Parent=$category2; ProductId="WHBA"; Name="HjulBalansering"; DisplayName="Hjul Balansering"; Description="Hjul Balansering"; TypeOfGood=$typeOfGood; Variants=@(`
        [pscustomobject]@{VariantId="P001"; Name="Hjulbalansering1"; DisplayName="Hjulbalansering";Price=0})}

}

if ($doCreateInventory) {
$InventoryName = "SoftProduct_InventorySet"
CreateInventorySet -Token $token -Data @{Name="$InventoryName"; DisplayName="SoftProduct Inventory Set"} -IdentityServiceUri "https://$authoringAlias"
CreateAssociateCatalog -Token $token -Data @{InventoryName="$InventoryName"; CatalogName=$catalog} -IdentityServiceUri "https://$authoringAlias"
CreateAssociateSellableItem -Token $token -Data @{InventoryName="$InventoryName"; ProductId="WHBA"; VariantId="P001"; Quantity=1000000; Price=0} -IdentityServiceUri "https://$authoringAlias"
CreateAssociateSellableItem -Token $token -Data @{InventoryName="$InventoryName"; ProductId="WHMORI"; VariantId="P001"; Quantity=1000000; Price=1450} -IdentityServiceUri "https://$authoringAlias"
CreateAssociateSellableItem -Token $token -Data @{InventoryName="$InventoryName"; ProductId="WHMORI"; VariantId="P002"; Quantity=1000000; Price=950} -IdentityServiceUri "https://$authoringAlias"
CreateAssociateSellableItem -Token $token -Data @{InventoryName="$InventoryName"; ProductId="WHCH"; VariantId="P001"; Quantity=1000000; Price=450} -IdentityServiceUri "https://$authoringAlias"
CreateAssociateSellableItem -Token $token -Data @{InventoryName="$InventoryName"; ProductId="WHCH"; VariantId="P002"; Quantity=1000000; Price=300} -IdentityServiceUri "https://$authoringAlias"
CreateAssociateSellableItem -Token $token -Data @{InventoryName="$InventoryName"; ProductId="TYHOGO"; VariantId="P001"; Quantity=1000000; Price=3095} -IdentityServiceUri "https://$authoringAlias"
CreateAssociateSellableItem -Token $token -Data @{InventoryName="$InventoryName"; ProductId="TYHOGO"; VariantId="P002"; Quantity=1000000; Price=2795} -IdentityServiceUri "https://$authoringAlias"
CreateAssociateSellableItem -Token $token -Data @{InventoryName="$InventoryName"; ProductId="TYHOGO"; VariantId="P003"; Quantity=1000000; Price=2595} -IdentityServiceUri "https://$authoringAlias"
CreateAssociateSellableItem -Token $token -Data @{InventoryName="$InventoryName"; ProductId="TYHOTYGO"; VariantId="P001"; Quantity=1000000; Price=3595} -IdentityServiceUri "https://$authoringAlias"
CreateAssociateSellableItem -Token $token -Data @{InventoryName="$InventoryName"; ProductId="TYHOTYGO"; VariantId="P002"; Quantity=1000000; Price=3295} -IdentityServiceUri "https://$authoringAlias"
CreateAssociateSellableItem -Token $token -Data @{InventoryName="$InventoryName"; ProductId="TYHOTYGO"; VariantId="P003"; Quantity=1000000; Price=3095} -IdentityServiceUri "https://$authoringAlias"
CreateAssociateSellableItem -Token $token -Data @{InventoryName="$InventoryName"; ProductId="TYHOSI"; VariantId="P001"; Quantity=1000000; Price=1995} -IdentityServiceUri "https://$authoringAlias"
CreateAssociateSellableItem -Token $token -Data @{InventoryName="$InventoryName"; ProductId="TYHOSI"; VariantId="P002"; Quantity=1000000; Price=1695} -IdentityServiceUri "https://$authoringAlias"
CreateAssociateSellableItem -Token $token -Data @{InventoryName="$InventoryName"; ProductId="TYHOSI"; VariantId="P003"; Quantity=1000000; Price=1495} -IdentityServiceUri "https://$authoringAlias"
CreateAssociateSellableItem -Token $token -Data @{InventoryName="$InventoryName"; ProductId="TYHOTYSI"; VariantId="P001"; Quantity=1000000; Price=2995} -IdentityServiceUri "https://$authoringAlias"
CreateAssociateSellableItem -Token $token -Data @{InventoryName="$InventoryName"; ProductId="TYHOTYSI"; VariantId="P002"; Quantity=1000000; Price=2695} -IdentityServiceUri "https://$authoringAlias"
CreateAssociateSellableItem -Token $token -Data @{InventoryName="$InventoryName"; ProductId="TYHOTYSI"; VariantId="P003"; Quantity=1000000; Price=2495} -IdentityServiceUri "https://$authoringAlias"
CreateAssociateSellableItem -Token $token -Data @{InventoryName="$InventoryName"; ProductId="TYHOBR"; VariantId="P001"; Quantity=1000000; Price=1495} -IdentityServiceUri "https://$authoringAlias"
CreateAssociateSellableItem -Token $token -Data @{InventoryName="$InventoryName"; ProductId="TYHOBR"; VariantId="P002"; Quantity=1000000; Price=1195} -IdentityServiceUri "https://$authoringAlias"
CreateAssociateSellableItem -Token $token -Data @{InventoryName="$InventoryName"; ProductId="TYHOBR"; VariantId="P003"; Quantity=1000000; Price=995} -IdentityServiceUri "https://$authoringAlias"
CreateAssociateSellableItem -Token $token -Data @{InventoryName="$InventoryName"; ProductId="TYHOTYBR"; VariantId="P001"; Quantity=1000000; Price=2495} -IdentityServiceUri "https://$authoringAlias"
CreateAssociateSellableItem -Token $token -Data @{InventoryName="$InventoryName"; ProductId="TYHOTYBR"; VariantId="P002"; Quantity=1000000; Price=2195} -IdentityServiceUri "https://$authoringAlias"
CreateAssociateSellableItem -Token $token -Data @{InventoryName="$InventoryName"; ProductId="TYHOTYBR"; VariantId="P003"; Quantity=1000000; Price=1995} -IdentityServiceUri "https://$authoringAlias"
}