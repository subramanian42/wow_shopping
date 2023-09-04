import 'dart:math' as math;

import 'package:flutter/foundation.dart' show PlatformDispatcher;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wow_shopping/app/assets.dart';

import 'package:wow_shopping/app/theme.dart';
import 'package:wow_shopping/backend/cart_repo.dart';
import 'package:wow_shopping/features/cart/widgets/cart_item.dart';

import 'package:wow_shopping/models/cart_item.dart';
import 'package:wow_shopping/utils/formatting.dart';
import 'package:wow_shopping/widgets/app_button.dart';
import 'package:wow_shopping/widgets/app_icon.dart';
import 'package:wow_shopping/widgets/app_panel.dart';
import 'package:wow_shopping/widgets/child_builder.dart';
import 'package:wow_shopping/widgets/common.dart';
import 'package:wow_shopping/widgets/top_nav_bar.dart';

@immutable
class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  ConsumerState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  final _cartPageKey = GlobalKey();
  final _checkoutPanelKey = GlobalKey();
  double _cartBottomInset = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final view = PlatformDispatcher.instance.implicitView!;
      final cartBox =
          _cartPageKey.currentContext!.findRenderObject() as RenderBox;
      final bottom = cartBox.localToGlobal(Offset(0.0, cartBox.size.height));
      final screenHeight = (view.physicalSize / view.devicePixelRatio).height;
      _cartBottomInset = screenHeight - bottom.dy;
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(cartStorageProvider).items;
    return SizedBox.expand(
      child: Material(
        key: _cartPageKey,
        child: ChildBuilder(
          builder: (BuildContext context, Widget child) {
            final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;
            return Padding(
              padding: EdgeInsets.only(
                bottom: math.max(0.0, keyboardHeight - _cartBottomInset),
              ),
              child: child,
            );
          },
          child: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverTopNavBar(
                      title: items.isEmpty
                          ? const Text('No items in your cart')
                          : Text('${items.length} items in your cart'),
                      pinned: true,
                      floating: true,
                    ),
                    const SliverToBoxAdapter(
                      child: _DeliveryAddressCta(
                          // FIXME: onChangeAddress ?
                          ),
                    ),
                    for (final item in items) //
                      SliverCartItemView(
                        key: Key(item.product.id),
                        item: item,
                      ),
                  ],
                ),
              ),
              CheckoutPanel(
                key: _checkoutPanelKey,
              ),
            ],
          ),
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

class CheckoutPanel extends ConsumerWidget {
  const CheckoutPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final total = ref.watch(cartTotalProvider);
    return AppPanel(
      padding: horizontalPadding24 + topPadding12 + bottomPadding24,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DefaultTextStyle.merge(
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Order amount:'),
                Text(formatCurrency(total)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CartQuantityWidget extends ConsumerStatefulWidget {
  const CartQuantityWidget({
    super.key,
    required this.item,
  });

  final CartItem item;

  @override
  ConsumerState<CartQuantityWidget> createState() => _CartQuantityWidgetState();
}

class _CartQuantityWidgetState extends ConsumerState<CartQuantityWidget> {
  late TextEditingController _quantityController;
  late FocusNode _quantityFocus;

  int get quantity => int.tryParse(_quantityController.text) ?? 0;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(
      text: widget.item.quantity.toString(),
    );
    _quantityController.addListener(_onQuantityChanged);
    _quantityFocus = FocusNode();
  }

  @override
  void didUpdateWidget(covariant CartQuantityWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.item.quantity != oldWidget.item.quantity) {
      _quantityController.text = widget.item.quantity.toString();
    }
  }

  void _onQuantityChanged() {
    ref.read(cartRepoProvider).updateQuantity(widget.item.product.id, quantity);
  }

  void _onMinusPressed() {
    final current = quantity;
    if (current == 1) {
      ref.read(cartRepoProvider).removeToCart(widget.item.product.id);
    } else {
      _quantityController.text = (quantity - 1).toString();
    }
  }

  void _onAddPressed() {
    _quantityController.text = (quantity + 1).toString();
  }

  @override
  void dispose() {
    _quantityFocus.dispose();
    _quantityController.removeListener(_onQuantityChanged);
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return Material(
      type: MaterialType.transparency,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: appButtonRadius,
        side: BorderSide(
          color: appTheme.appColor,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: _onMinusPressed,
              child: Padding(
                padding: leftPadding12 + verticalPadding4 + verticalPadding2,
                child: ValueListenableBuilder(
                  valueListenable: _quantityController,
                  builder: (BuildContext context, TextEditingValue value,
                      Widget? child) {
                    return AppIcon(
                      iconAsset:
                          quantity <= 1 ? Assets.iconRemove : Assets.iconMinus,
                      color: appTheme.appColor,
                    );
                  },
                ),
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Your total amount of discount:'),
                Text('-'),
              ],
            ),
            verticalMargin12,
            AppButton(
              onPressed: () {
                // FIXME: goto checkout
              },
              style: AppButtonStyle.highlighted,
              label: 'Checkout',
            ),
          ],
        ),
      ),
    );
  }
}
