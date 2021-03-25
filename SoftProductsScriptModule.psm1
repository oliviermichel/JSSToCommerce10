
Function BuildHeaders {
    [CmdletBinding()]
    PARAM
    (
        [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Token
    )
    return @{"ShopName"="ShopSite"
        "ShopperId"="ShopperId"
        "Language"="en"
        "Currency"="SEK"
        "Environment"="HedinAuthoring"
        "GeoLocation"="IpAddress=1.0.0.0"
        "CustomerId"="CustomerId"
        "Authorization"="Bearer $token"}
}

Function GetCategoryVersion {
    [CmdletBinding()]
    PARAM
    (
        [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Token,
        [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Category,
        [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$IdentityServiceUri
    )

    $contentType = 'application/json'
    $headers = BuildHeaders($token)
    $uri = "$IdentityServiceUri/api/Categories"
    $Res = Invoke-RestMethod -Uri $uri -ContentType $contentType -Method Get -Headers $headers

    $catVersion = ($Res.value | Where-Object { $_.FriendlyId -eq $Category} | Select-Object Version)

    if ($null -eq $catVersion -or $catVersion.Count -eq 0) {
        return 0
    }

    return $catVersion[0].Version

}

Function GetInventorySetVersion {
    [CmdletBinding()]
    PARAM
    (
        [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Token,
        [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Name,
        [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$IdentityServiceUri
    )

    $contentType = 'application/json'
    $headers = BuildHeaders($token)
    $uri = "$IdentityServiceUri/api/InventorySets"
    $Res = Invoke-RestMethod -Uri $uri -ContentType $contentType -Method Get -Headers $headers

    $catVersion = ($Res.value | Where-Object { $_.FriendlyId -eq $Name} | Select-Object Version)

    if ($null -eq $catVersion -or $catVersion.Count -eq 0) {
        return 0
    }

    return $catVersion[0].Version

}

Function GetCatalogVersion {
    [CmdletBinding()]
    PARAM
    (
        [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Token,
        [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Catalog,
        [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$IdentityServiceUri
    )

    $contentType = 'application/json'
    $headers = BuildHeaders($token)
    $uri = "$IdentityServiceUri/api/Catalogs"
    $Res = Invoke-RestMethod -Uri $uri -ContentType $contentType -Method Get -Headers $headers

    $catVersion = ($Res.value | Where-Object { $_.FriendlyId -eq $Catalog} | Select-Object Version)

    if ($null -eq $catVersion -or $catVersion.Count -eq 0) {
        return 0
    }

    return $catVersion[0].Version

}

Function GetSellableItemVersion {
    [CmdletBinding()]
    PARAM
    (
        [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Token,
        [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$SellableItem,
        [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$IdentityServiceUri
    )

    $contentType = 'application/json'
    $headers = BuildHeaders($token)
    $uri = "$IdentityServiceUri/api/SellableItems"
    $Res = Invoke-RestMethod -Uri $uri -ContentType $contentType -Method Get -Headers $headers

    
    $catVersion = ($Res.value | Where-Object { $_.FriendlyId -eq $SellableItem} | Select-Object Version)

    if ($null -eq $catVersion -or $catVersion.Count -eq 0) {
        return 0
    }

    return $catVersion[0].Version

}

Function ExistsCatalog {
    [CmdletBinding()]
    PARAM
    (
        [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Token,
        [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Catalog,
        [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$IdentityServiceUri
    )

    $contentType = 'application/json'
    $headers = BuildHeaders($token)
    $uri = "$IdentityServiceUri/api/Catalogs"
    $Res = Invoke-RestMethod -Uri $uri -ContentType $contentType -Method Get -Headers $headers

    
    $catVersion = ($Res.value | Where-Object { $_.FriendlyId -eq $Catalog} | Select-Object Version)

    if ($null -eq $catVersion -or $catVersion.Count -eq 0) {
        return $False
    }

    return $True
}

Function AddInventorySet {
    [CmdletBinding()]
    PARAM
    (
    [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Token,
    [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$IdentityServiceUri,
    [string] $Name,
    [string] $DisplayName
    )

    $body = @{entityView=@{Name="Details";DisplayName="Details";EntityId="";Action="AddInventorySet";ItemId="";Properties=@( `
    [pscustomobject]@{Name="Version";DisplayName="Version";Value="1";IsHidden=$True;OriginalType="System.Int32";IsReadOnly=$True;IsRequired=$True},`
    [pscustomobject]@{Name="Name";DisplayName="Name";Value=$Name;IsHidden=$False;OriginalType="System.String";IsReadOnly=$False;IsRequired=$True},`
    [pscustomobject]@{Name="DisplayName";DisplayName="Display Name";Value=$DisplayName;IsHidden=$False;OriginalType="System.String";IsReadOnly=$False;IsRequired=$True},`
    [pscustomobject]@{Name="Description";DisplayName="Description";Value=$DisplayName;IsHidden=$False;OriginalType="System.String";IsReadOnly=$False;IsRequired=$False}`
    );DisplayRank=500;UiHint="Flat"}} | ConvertTo-Json -Depth 100

    
    $contentType = 'application/json'
    $headers = BuildHeaders($token)
    $uri = "$IdentityServiceUri/api/DoAction()"
    $Res = Invoke-RestMethod -Uri $uri -ContentType $contentType -Method Post -Headers $headers -Body $body

    return $Res.ResponseCode

}

Function AssociateCatalog {
    [CmdletBinding()]
    PARAM
    (
    [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Token,
    [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$IdentityServiceUri,
    [string] $InventoryName,
    [string] $Version,
    [string] $CatalogName
    )

    $body = @{entityView=@{Name="InventorySetCatalogs";DisplayName="Catalogs";EntityId="Entity-InventorySet-$InventoryName";Action="AssociateCatalog";ItemId="";Properties=@( `
    [pscustomobject]@{Name="Version";DisplayName="Version";Value=$Version;IsHidden=$True;OriginalType="System.Int32";IsReadOnly=$True;IsRequired=$True},`
    [pscustomobject]@{Name="CatalogName";DisplayName="Catalog Name";Value=$CatalogName;IsHidden=$False;OriginalType="System.String";IsReadOnly=$False;IsRequired=$True}`
    );DisplayRank=500;UiHint="Flat"}} | ConvertTo-Json -Depth 100

    
    $contentType = 'application/json'
    $headers = BuildHeaders($token)
    $uri = "$IdentityServiceUri/api/DoAction()"
    $Res = Invoke-RestMethod -Uri $uri -ContentType $contentType -Method Post -Headers $headers -Body $body

    
    $result = $Res.ResponseCode
    if ($result -ne "Ok") {
        $result = $res.Messages[0].CommerceTermKey
    }

    return $result

}

Function DeleteCatalog {
    [CmdletBinding()]
    PARAM
    (
    [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Token,
    [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$IdentityServiceUri,
    [string] $Catalog
    )

    $CatalogEntity = "Entity-Catalog-$Catalog"
    
    $Version = GetCatalogVersion -Token $token -Catalog $Catalog -IdentityServiceUri $IdentityServiceUri 
    $Version = $Version -as [int]

    $body = @{entityView=@{Name="";DisplayName="";EntityId="";Action="DeleteCatalog";ItemId="$CatalogEntity";Properties=@( `
    [pscustomobject]@{Name="Version";DisplayName="Version";Value=$null;IsHidden=$True;OriginalType="System.Int32";IsReadOnly=$True;IsRequired=$True}`
    );DisplayRank=500}} | ConvertTo-Json -Depth 100

    Write-Host($body)
    $contentType = 'application/json'
    $headers = BuildHeaders($token)
    $uri = "$IdentityServiceUri/api/DoAction()"
    $Res = Invoke-RestMethod -Uri $uri -ContentType $contentType -Method Post -Headers $headers -Body $body
    Write-Host($Res)

    Write-Host("Delete catalog: $Res.ResponseCode")

    return $Res.ResponseCode
}

Function DeleteSellableItem {
    [CmdletBinding()]
    PARAM
    (
    [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Token,
    [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$IdentityServiceUri,
    [string] $CategoryId,
    [string] $SellableItem
    )

    # CategoryId has to be inte the form like "SoftProducts-HedinTyreServices". Check result in Postman for Categories request
    $ItemId = "Entity-SellableItem-$SellableItem"
	$EntityId = "Entity-Category-$CategoryId"
    
    $Version = GetCategoryVersion -Token $token -Category $CategoryId -IdentityServiceUri $IdentityServiceUri 
	
	
    $body = @{entityView=@{Name="DeleteSellableItem";DisplayName="DeleteSellableItem";EntityId=$EntityId;Action="DeleteSellableItem";EntityVersion=1;ItemId=$ItemId;VersionedItemId="$ItemId-1";Properties=@( `
    [pscustomobject]@{Name="Version";DisplayName="Version";Value="$Version";IsHidden=$True;OriginalType="System.Int32";IsReadOnly=$True;IsRequired=$True},`
	[pscustomobject]@{Name="DeleteOption";DisplayName="Delete Option";Value="";IsHidden=$True;OriginalType="System.String";IsReadOnly=$False;IsRequired=$False}`
    );DisplayRank=500;UiHint="Flat";Icon="chart_column_stacked"}} | ConvertTo-Json -Depth 100
	
	
    $contentType = 'application/json'
    $headers = BuildHeaders($token)
    $uri = "$IdentityServiceUri/api/DoAction()"
    $Res = Invoke-RestMethod -Uri $uri -ContentType $contentType -Method Post -Headers $headers -Body $body
    
    if ($Res.ResponseCode -eq "Ok") {
		return "$SellableItem deleted"
	} else {
		return $Res.Messages[0].Text
	}
}

Function AssociateSellableItem {
    [CmdletBinding()]
    PARAM
    (
    [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Token,
    [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$IdentityServiceUri,
    [string] $InventoryName,
    [string] $Version,
    [string] $ProductId,
    [string] $VariantId,
    [int] $Quantity,
	[int] $Price
    )

    $body = @{entityView=@{Name="AssociateSellableItem";DisplayName="Associate Sellable Item";EntityId="Entity-InventorySet-$InventoryName";Action="AssociateSellableItem";ItemId="";Properties=@( `
    [pscustomobject]@{Name="Version";DisplayName="Version";Value=$Version;IsHidden=$True;OriginalType="System.Int32";IsReadOnly=$True;IsRequired=$True},`
    [pscustomobject]@{Name="SellableItem";DisplayName="Sellable Item";Value="Entity-SellableItem-$ProductId|$VariantId";IsHidden=$False;OriginalType="System.String";IsReadOnly=$False;IsRequired=$True},`
    [pscustomobject]@{Name="Quantity";DisplayName="Quantity";Value="$Quantity";IsHidden=$False;OriginalType="System.Int32";IsReadOnly=$False;IsRequired=$True},`
	[pscustomobject]@{Name="InvoiceUnitPrice";DisplayName="Invoice Unit Price";Value="$Price";IsHidden=$False;OriginalType="System.Decimal";IsReadOnly=$False;IsRequired=$False},`
	[pscustomobject]@{Name="InvoiceUnitPriceCurrency";DisplayName="Invoice Unit Price Currency";Value="SEK";IsHidden=$False;OriginalType="System.String";IsReadOnly=$False;IsRequired=$False}`
    );DisplayRank=500;UiHint="Flat"}} | ConvertTo-Json -Depth 100

    
    $contentType = 'application/json'
    $headers = BuildHeaders($token)
    $uri = "$IdentityServiceUri/api/DoAction()"
    $Res = Invoke-RestMethod -Uri $uri -ContentType $contentType -Method Post -Headers $headers -Body $body

    return $Res.ResponseCode

}

Function AddCatalog {
    [CmdletBinding()]
    PARAM
    (
    [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Token,
    [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$IdentityServiceUri,
    [string] $Catalog,
    [string] $DisplayName
    )

    $body = @{entityView=@{Name="Details";DisplayName="Details";EntityId="";Action="AddCatalog";ItemId="";Properties=@( `
    [pscustomobject]@{Name="Name";DisplayName="Name";Value=$Catalog;IsHidden=$False;OriginalType="System.String";IsReadOnly=$False;IsRequired=$True},`
    [pscustomobject]@{Name="DisplayName";DisplayName="Display Name";Value=$DisplayName;IsHidden=$False;OriginalType="System.String";IsReadOnly=$False;IsRequired=$True},`
    [pscustomobject]@{Name="PriceBookName";DisplayName="Price Book Name";Value="$Catalog_Price_Book";IsHidden=$False;OriginalType="System.String";IsReadOnly=$False;IsRequired=$False},`
    [pscustomobject]@{Name="PromotionBookName";DisplayName="Promotion Book Name";Value="$Catalog_Promotion_Book";IsHidden=$False;OriginalType="System.String";IsReadOnly=$False;IsRequired=$True}`
    );DisplayRank=500;UiHint="Flat"}} | ConvertTo-Json -Depth 100

    
    $contentType = 'application/json'
    $headers = BuildHeaders($token)
    $uri = "$IdentityServiceUri/api/DoAction()"
    $Res = Invoke-RestMethod -Uri $uri -ContentType $contentType -Method Post -Headers $headers -Body $body

    return $Res.ResponseCode

}

Function AddCategory {
    [CmdletBinding()]
    PARAM
    (
    [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Token,
    [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$IdentityServiceUri,
    [string] $Category,
    [string] $Version,
    [string] $Name,
    [string] $DisplayName,
    [string] $Description
    )

    $body = @{entityView=@{Name="Details";DisplayName="Details";EntityId=$Category;Action="AddCategory";ItemId="";Properties=@( `
    [pscustomobject]@{Name="Version";DisplayName="Version";Value=$Version;IsHidden=$True;OriginalType="System.Int32";IsReadOnly=$True;IsRequired=$True},`
    [pscustomobject]@{Name="Name";DisplayName="Name";Value=$Name;IsHidden=$False;OriginalType="System.String";IsReadOnly=$False;IsRequired=$True},`
    [pscustomobject]@{Name="DisplayName";DisplayName="Display Name";Value=$DisplayName;IsHidden=$False;OriginalType="System.String";IsReadOnly=$False;IsRequired=$True},`
    [pscustomobject]@{Name="Description";DisplayName="Description";Value=$Description;IsHidden=$False;OriginalType="System.String";IsReadOnly=$False;IsRequired=$False},`
    [pscustomobject]@{Name="IsSearchable";DisplayName="Is Searchable";Value="true";IsHidden=$False;OriginalType="System.String";IsReadOnly=$False;IsRequired=$False}`
    );DisplayRank=500;UiHint="Flat";Icon="dashboard"}} | ConvertTo-Json -Depth 100

    $contentType = 'application/json'
    $headers = BuildHeaders($token)
    $uri = "$IdentityServiceUri/api/DoAction()"
    $Res = Invoke-RestMethod -Uri $uri -ContentType $contentType -Method Post -Headers $headers -Body $body

    return $Res.ResponseCode

}

Function AddSellableItem {
    [CmdletBinding()]
    PARAM
    (
    [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Token,
    [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$IdentityServiceUri,
    [string] $Category,
    [string] $Version,
    [string] $ProductId,
    [string] $Name,
    [string] $DisplayName,
    [string] $Description,
    [string] $Brand,
    [string] $Manufacturer,
    [string] $TypeOfGood,
    [string] $Tags
    )

    $body = @{entityView=@{Name="Details";DisplayName="Details";EntityId=$Category;Action="AddSellableItem";ItemId="";Properties=@( `
    [pscustomobject]@{Name="Version";DisplayName="Version";Value=$Version;IsHidden=$True;OriginalType="System.Int32";IsReadOnly=$True;IsRequired=$True},`
    [pscustomobject]@{Name="ProductId";DisplayName="Product Id";Value=$ProductId;IsHidden=$False;OriginalType="System.String";IsReadOnly=$False;IsRequired=$True},`
    [pscustomobject]@{Name="Name";DisplayName="Name";Value=$Name;IsHidden=$False;OriginalType="System.String";IsReadOnly=$False;IsRequired=$True},`
    [pscustomobject]@{Name="DisplayName";DisplayName="Display Name";Value=$DisplayName;IsHidden=$False;OriginalType="System.String";IsReadOnly=$False;IsRequired=$True},`
    [pscustomobject]@{Name="Description";DisplayName="Description";Value=$Description;IsHidden=$False;OriginalType="System.String";IsReadOnly=$False;IsRequired=$False},`
    [pscustomobject]@{Name="Brand";DisplayName="Brand";Value=$Brand;IsHidden=$False;OriginalType="System.String";IsReadOnly=$False;IsRequired=$False},`
    [pscustomobject]@{Name="Manufacturer";DisplayName="Manufacturer";Value=$Manufacturer;IsHidden=$False;OriginalType="System.String";IsReadOnly=$False;IsRequired=$False},`
    [pscustomobject]@{Name="TypeOfGood";DisplayName="TypeOfGood";Value=$TypeOfGood;IsHidden=$False;OriginalType="System.String";IsReadOnly=$False;IsRequired=$False},`
    [pscustomobject]@{Name="Tags";DisplayName="Tags";Value=$Tags;IsHidden=$False;OriginalType="List";IsReadOnly=$False;IsRequired=$False;UiType="Tags"}`
    );DisplayRank=500;UiHint="Flat";Icon="dashboard"}} | ConvertTo-Json -Depth 100

    
    $contentType = 'application/json'
    $headers = BuildHeaders($token)
    $uri = "$IdentityServiceUri/api/DoAction()"
    $Res = Invoke-RestMethod -Uri $uri -ContentType $contentType -Method Post -Headers $headers -Body $body

    if ($Res.ResponseCode -ne "Ok") {
        Write-Host($body)
        Write-Host($Res)
        Write-Host($Res.Messages[0])
    }
    
    return $Res.ResponseCode

}


Function AddVariant {
    [CmdletBinding()]
    PARAM
    (
    [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Token,
    [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$IdentityServiceUri,
    [string] $SellableItem,
    [string] $Version,
    [string] $VariantId,
    [string] $Name,
    [string] $DisplayName
    )

    $body = @{entityView=@{Name="Variant";DisplayName="Variant";EntityId=$SellableItem;Action="AddSellableItemVariant";ItemId="";Properties=@( `
    [pscustomobject]@{Name="Version";DisplayName="Version";Value=$Version;IsHidden=$True;OriginalType="System.Int32";IsReadOnly=$True;IsRequired=$True},`
    [pscustomobject]@{Name="VariantId";DisplayName="Variant Id";Value=$VariantId;IsHidden=$False;OriginalType="System.String";IsReadOnly=$False;IsRequired=$True},`
    [pscustomobject]@{Name="Name";DisplayName="Name";Value=$Name;IsHidden=$False;OriginalType="System.String";IsReadOnly=$False;IsRequired=$True;UiType="PostmanSellableItemVariant"},`
    [pscustomobject]@{Name="DisplayName";DisplayName="Display Name";Value=$DisplayName;IsHidden=$False;OriginalType="System.String";IsReadOnly=$False;IsRequired=$True}`
    );DisplayRank=500;UiHint="Flat";Icon="dashboard"}} | ConvertTo-Json -Depth 100

    
    $contentType = 'application/json'
    $headers = BuildHeaders($token)
    $uri = "$IdentityServiceUri/api/DoAction()"
    $Res = Invoke-RestMethod -Uri $uri -ContentType $contentType -Method Post -Headers $headers -Body $body

    if ($Res.ResponseCode -eq "Error") {
        Write-Host($body)
        Write-Host($Res)
    }
    
    return $Res.ResponseCode
}

Function AddPrice {
    [CmdletBinding()]
    PARAM
    (
    [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Token,
    [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$IdentityServiceUri,
	[string] $SellableItem,
	[string] $Version,
    [string] $VariantId,
    [int] $Price
    )

    #$body = @{itemId=$variantId;prices=@( `
    #[pscustomobject]@{CurrencyCode="SEK";Amount=$Price}`
    #)} | ConvertTo-Json -Depth 100
	
	$body = @{entityView=@{Name="SellableItemListPricing";DisplayName="List Pricing";EntityId=$SellableItem;Action="AddSellableItemListPrice";ItemId=$VariantId;VersionedItemId="$VariantId-1";Properties=@( `
    [pscustomobject]@{Name="Version";DisplayName="Version";Value=$Version;IsHidden=$True;OriginalType="System.Int32";IsReadOnly=$True;IsRequired=$True},`
    [pscustomobject]@{Name="Currency";DisplayName="Currency";Value="SEK";IsHidden=$False;OriginalType="System.String";IsReadOnly=$False;IsRequired=$True},`
    [pscustomobject]@{Name="ListPrice";DisplayName="List Price";Value="$Price";IsHidden=$False;OriginalType="System.Decimal";IsReadOnly=$False;IsRequired=$True}`
    );DisplayRank=500;UiHint="Flat";Icon="dashboard"}} | ConvertTo-Json -Depth 100

    $contentType = 'application/json'
    $headers = BuildHeaders($token)
    #$uri = "$IdentityServiceUri/api/UpdateListPrices()"
	$uri = "$IdentityServiceUri/api/DoAction()"
    $Res = Invoke-RestMethod -Uri $uri -ContentType $contentType -Method Post -Headers $headers -Body $body
    if ($Res.ResponseCode -ne "Ok") {
		Write-Host($uri)
		Write-Host($body)
		Write-Host($Res)
		return $Res.Messages[0]
	}
    return $Res.ResponseCode
}

Function CreateInventorySet {
    [CmdletBinding()]
    PARAM
    (
    [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Token,
    [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$IdentityServiceUri,
    [pscustomobject] $Data
    )

    $Name = $Data.Name
    $DisplayName = $Data.DisplayName

    $versionInventory = GetInventorySetVersion -Token $token -Name $Name -IdentityServiceUri $IdentityServiceUri


    if ($versionInventory -eq 0) {
        $result = AddInventorySet -Token $token -Name $Name -DisplayName $DisplayName -IdentityServiceUri $IdentityServiceUri
        if ($result -ne "Ok") {
            Write-Host("Error adding inventorySet $name : $result")
            Exit 1
        }
        $versionInventory = GetInventorySetVersion -Token $token -Name $Name -IdentityServiceUri $IdentityServiceUri
        Write-Host("Created Inventory Set $Name")
    } else {
		Write-Host("Already existing Inventory Set $Name")
	}


}

Function CreateAssociateCatalog {
    [CmdletBinding()]
    PARAM
    (
    [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Token,
    [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$IdentityServiceUri,
    [pscustomobject] $Data
    )

    $InventoryName = $Data.InventoryName
    $CatalogName = $Data.CatalogName

    $versionInventory = GetInventorySetVersion -Token $token -Name $InventoryName -IdentityServiceUri $IdentityServiceUri
    
    $result = AssociateCatalog -Token $token -InventoryName $InventoryName -Version $versionInventory -CatalogName $CatalogName -IdentityServiceUri $IdentityServiceUri

    if ($result -eq "CatalogAlreadyAssociated") {
        Write-Host("Already associated catalog $CatalogName to inventory $InventoryName : $result")
    } elseif ($result -eq "Ok"){
        Write-Host("Associated catalog $CatalogName to inventory $InventoryName : $result")
    } else {
        Write-Host("Error Associated catalog $CatalogName to inventory $InventoryName : $result")
        Exit 1
    }
}

Function CreateAssociateSellableItem {
    [CmdletBinding()]
    PARAM
    (
    [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Token,
    [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$IdentityServiceUri,
    [pscustomobject] $Data
    )

    $InventoryName = $Data.InventoryName
    $ProductId = $Data.ProductId
    $VariantId = $Data.VariantId
    $Quantity = $Data.Quantity
	$Price = $Data.Price

    $versionInventory = GetInventorySetVersion -Token $token -Name $InventoryName -IdentityServiceUri $IdentityServiceUri

    $result = AssociateSellableItem -Token $token -InventoryName $InventoryName -Version $versionInventory -ProductId $ProductId -VariantId $VariantId -Quantity $Quantity -Price $Price -IdentityServiceUri $IdentityServiceUri
    if ($result -ne "Ok") {
        Write-Host("Error Associated sellableItem $ProductId  $VariantId to inventory $InventoryName : $result")
        Exit 1
    }
    Write-Host("Associated sellableItem $ProductId  $VariantId to inventory $InventoryName : $result")


}


Function CreateSoftProductCatalog {
    [CmdletBinding()]
    PARAM
    (
    [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Token,
    [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$IdentityServiceUri,
    [pscustomobject] $Data
    )

    $catalog = $Data.Catalog
    
    $versionCatalog = GetCatalogVersion -Token $token -Catalog $catalog -IdentityServiceUri $IdentityServiceUri


    if ($versionCatalog -eq 0) {
        $result = AddCatalog -Token $token -Catalog $catalog -DisplayName $catalog -IdentityServiceUri $IdentityServiceUri
        if ($result -ne "Ok") {
            Write-Host("Error adding catalog $catalog : $result")
            Exit 1
        }
        $versionCatalog = GetCatalogVersion -Token $token -Catalog $catalog -IdentityServiceUri $IdentityServiceUri
        Write-Host("Created catalog $catalog")
    } else {
		Write-Host("Already existing catalog $catalog")
	}
}

Function CreateSoftProductCategoryFromCatalog {
    [CmdletBinding()]
    PARAM
    (
    [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Token,
    [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$IdentityServiceUri,
    [pscustomobject] $Data
    )

    $catalog = $Data.Catalog
    $category = $Data.Name
    $categoryDisplayName = $Data.DisplayName
    $category_friendlyId = "$catalog-$category"
    $catalogEntity = "Entity-Catalog-$catalog"
    
    $version = GetCatalogVersion -Token $token -Catalog $catalog -IdentityServiceUri $IdentityServiceUri
    $versionCategory = GetCategoryVersion -Token $token -Category $category_friendlyId -IdentityServiceUri $IdentityServiceUri

    if ($versionCategory -eq 0) {
        $result = AddCategory -Token $token -Category $catalogEntity -Version $version -Name $category -DisplayName $categoryDisplayName  -Description $categoryDisplayName -IdentityServiceUri $IdentityServiceUri
        if ($result -ne "Ok") {
            Write-Host("Error adding category $category : $result")
            Exit 1
        }
        $versionCategory = GetCategoryVersion -Token $token -Category $category_friendlyId -IdentityServiceUri $IdentityServiceUri
        Write-Host("Created category $category")
    }else {
		Write-Host("Already existing category $category")
	}
}

Function CreateSoftProductCategoryFromCategory {
    [CmdletBinding()]
    PARAM
    (
    [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Token,
    [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$IdentityServiceUri,
    [pscustomobject] $Data
    )

    $catalog = $Data.Catalog
    $category = $Data.Name
    $parent = $Data.Parent
    $categoryDisplayName = $Data.DisplayName
    $category_friendlyId = "$catalog-$category"
    $catalogEntity = "Entity-Category-$catalog-$parent"
    
    $version = GetCategoryVersion -Token $token -Category "$catalog-$parent" -IdentityServiceUri $IdentityServiceUri
    $versionCategory = GetCategoryVersion -Token $token -Category $category_friendlyId -IdentityServiceUri $IdentityServiceUri

    if ($versionCategory -eq 0) {
        $result = AddCategory -Token $token -Category $catalogEntity -Version $version -Name $category -DisplayName $categoryDisplayName  -Description $categoryDisplayName -IdentityServiceUri $IdentityServiceUri
        if ($result -ne "Ok") {
            Write-Host("Error adding category $category : $result")
            Exit 1
        }
        $versionCategory = GetCategoryVersion -Token $token -Category $category_friendlyId -IdentityServiceUri $IdentityServiceUri
        Write-Host("Created category $category")
    }else {
		Write-Host("Already existing category $category")
	}
}

Function CreateSellableItem {
    [CmdletBinding()]
    PARAM
    (
    [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Token,
    [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$IdentityServiceUri,
    [pscustomobject] $Data
    )

    $catalog = $Data.Catalog
    $category = $Data.Parent
    $sellableItem = $Data.ProductId
    $siName = $Data.Name
    $siDisplayName = $Data.DisplayName
    $siDescription = $Data.Description
    $typeOfGood = $Data.TypeOfGood
    $category_friendlyId = "$catalog-$category"
    $sellableItemEntity = "Entity-Category-$catalog-$category"
    
    $version = GetCategoryVersion -Token $token -Category $category_friendlyId -IdentityServiceUri $IdentityServiceUri

    $versionSellableItem = GetSellableItemVersion -Token $token -SellableItem $sellableItem -IdentityServiceUri $IdentityServiceUri

    if ($versionSellableItem -eq 0) {
        $result = AddSellableItem -Token $token -Category $sellableItemEntity -Version $version -ProductId $sellableItem -Name $siName -DisplayName $siDisplayName -Description $siDescription -TypeOfGood $typeOfGood -IdentityServiceUri $IdentityServiceUri
        if ($result -ne "Ok") {
            Write-Host("Error adding sellable item $sellableItem : $result")
            Exit 1
        }
        $versionSellableItem = GetSellableItemVersion -Token $token -SellableItem $sellableItem -IdentityServiceUri $IdentityServiceUri

        $Data.Variants | ForEach-Object -Process {
            $variantId = $_.VariantId
            $name = $_.Name
            $displayName = $_.DisplayName
            $price = $_.Price

            $result = AddVariant -Token $token -SellableItem "Entity-SellableItem-$sellableItem" -Version $versionSellableItem -VariantId $variantId -Name $name -DisplayName $displayName -IdentityServiceUri $IdentityServiceUri
            if ($result -ne "Ok") {
                Write-Host("Error adding variant $name : $result")
                Exit 1
            }
            $versionSellableItem++
            #$result = AddPrice -Token $token -VariantId "$catalog|$sellableItem|$variantId" -Price $price -IdentityServiceUri $IdentityServiceUri
			$result = AddPrice -Token $token -SellableItem "Entity-SellableItem-$sellableItem" -Version $versionSellableItem -VariantId "$variantId" -Price $price -IdentityServiceUri $IdentityServiceUri
            if ($result -ne "Ok") {
                Write-Host("Error adding price $name : $result")
                Exit 1
            }
            $versionSellableItem++
        }
        Write-Host("Created sellable item $sellableItem")
    }else {
		Write-Host("Already existing sellable item $sellableItem")
	}
}
