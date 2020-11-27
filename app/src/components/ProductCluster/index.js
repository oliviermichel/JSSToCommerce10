import React from 'react';
import ProductList from '../../shared/components/productlist';

console.log("in ProductCluster");
// ProductCluster displays products from the resolved datasource
const ProductCluster = ({fields}) => (
  <div className='productcluster'>
    <h1 className='productcluster__title'>{fields.heading}</h1>
    {<ProductList products={fields.products}/>}
  </div>
);

export default ProductCluster;
