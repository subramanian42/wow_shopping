import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import 'package:wow_shopping/features/cart/checkout_page.dart';
import 'package:wow_shopping/features/cart/notifier/cart_notifier.dart';
import 'package:wow_shopping/features/cart/widgets/cart_item.dart';
import 'package:wow_shopping/features/cart/widgets/cart_page_layout.dart';
import 'package:wow_shopping/features/cart/widgets/checkout_panel.dart';
import 'package:wow_shopping/models/cart_item.dart';
import 'package:wow_shopping/widgets/app_button.dart';
import 'package:wow_shopping/widgets/common.dart';
import 'package:wow_shopping/widgets/top_nav_bar.dart';

@immutable
class CartPage extends WatchingStatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final cartItems = watchPropertyValue<CartNotifier, List<CartItem>>(
        (notifier) => notifier.cartItems);
    return Material(
      child: CartPageLayout(
        checkoutPanel: CheckoutPanel(
          onPressed: () {
            Navigator.of(context).push(CheckoutPage.route());
          },
          label: 'Checkout',
        ),
        content: CustomScrollView(
          slivers: [
            SliverTopNavBar(
              title: cartItems.isEmpty
                  ? const Text('No items in your cart')
                  : Text('${cartItems.length} items in your cart'),
              pinned: true,
              floating: true,
            ),
            const SliverToBoxAdapter(
              child: _DeliveryAddressCta(
                  // FIXME: onChangeAddress ?
                  ),
            ),
            for (final item in cartItems) //
              SliverCartItemView(
                key: Key(item.product.id),
                item: item,
              ),
          ],
        ),
      ),
    );
  }
}

@immutable
class _DeliveryAddressCta extends StatelessWidget {
  const _DeliveryAddressCta();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: horizontalPadding12 + verticalPadding16,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'Delivery to '),
                      TextSpan(
                        // FIXME: replace with selected address name
                        text: 'Designer Techcronus',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                verticalMargin4,
                // FIXME: replace with selected address
                Text(
                  '4/C Center Point,Panchvati, '
                  'Ellisbridge, Ahmedabad, Gujarat 380006',
                ),
              ],
            ),
          ),
          AppButton(
            onPressed: () {
              // FIXME open Delivery address screen
            },
            style: AppButtonStyle.outlined,
            label: 'Change',
          ),
        ],
      ),
    );
  }
}
