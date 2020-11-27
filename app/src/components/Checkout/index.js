import React, { useContext } from 'react';
import i18n from 'i18next';
import FulfillmentInfoForm from './FulfillmentInfoForm';
import { CartContext } from '../../lib/commerce';

const Checkout = () => {
    const cart = useContext(CartContext);

    return (
        <article className="checkout">
            <header>
                <h1 className="checkout__title">{i18n.t('checkout-title')}</h1>
            </header>
            <section className="checkout__info">
                <FulfillmentInfoForm actions={cart.actions} />
            </section>
        </article>
    );
}

export default Checkout;
