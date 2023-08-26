import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wow_shopping/app/assets.dart';

import 'package:wow_shopping/app/theme.dart';
import 'package:wow_shopping/backend/cart_repo.dart';

import 'package:wow_shopping/models/cart_item.dart';
import 'package:wow_shopping/utils/formatting.dart';
import 'package:wow_shopping/widgets/app_button.dart';
import 'package:wow_shopping/widgets/common.dart';
import 'package:wow_shopping/widgets/top_nav_bar.dart';

@immutable
class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  ConsumerState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CartItem>>(
        initialData: ref.read(cartRepoProvider).currentCartItems,
        stream: ref.read(cartRepoProvider).streamCartItems,
        builder:
            (BuildContext context, AsyncSnapshot<List<CartItem>> snapshot) {
          final items = snapshot.requireData;
          return SizedBox.expand(
            child: Material(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const TopNavBar(
                    title: Text('2 items in your cart'),
                  ),
                  const _DeliveryAddressCta(
                      // FIXME: onChangeAddress ?
                      ),
                  for (final item in items) //
                    _CartItemView(
                      key: Key(item.product.id),
                      item: item,
                    ),
                ],
              ),
            ),
          );
        });
  }
}

@immutable
class _DeliveryAddressCta extends StatelessWidget {
  const _DeliveryAddressCta();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: appDividerColor, width: 1.5),
        ),
      ),
      child: Padding(
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
      ),
    );
  }
}

@immutable
class _CartItemView extends ConsumerWidget {
  const _CartItemView({
    required super.key,
    required this.item,
  });

  final CartItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: bottomPadding12 + horizontalPadding12,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: allPadding8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item.product.title),
                Text(
                  formatCurrency(item.product.price),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: allPadding8 - topPadding8,
            child: AppButton(
              onPressed: () =>
                  ref.read(cartRepoProvider).removeToCart(item.product.id),
              iconAsset: Assets.iconRemove,
              label: 'Remove',
            ),
          ),
        ],
      ),
    );
  }
}
