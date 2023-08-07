import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow_shopping/app/assets.dart';
import 'package:wow_shopping/app/theme.dart';
import 'package:wow_shopping/backend/backend.dart';
import 'package:wow_shopping/models/product_item.dart';
import 'package:wow_shopping/widgets/app_icon.dart';
import 'package:wow_shopping/widgets/wishlist_button/bloc/wishlist_button_bloc.dart';

class WishlistButton extends StatelessWidget {
  const WishlistButton({
    super.key,
    required this.item,
  });

  final ProductItem item;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          WishlistButtonBloc(wishlistRepo: context.wishlistRepo, item: item)
            ..add(WishlistToggleStarted()),
      child: const WishlistButtonView(),
    );
  }
}

class WishlistButtonView extends StatelessWidget {
  const WishlistButtonView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishlistButtonBloc, WishlistButtonState>(
      builder: (context, state) {
        return IconButton(
          onPressed: () => context
              .read<WishlistButtonBloc>()
              .add(TogglePressed(value: !state.isWishlisted)),
          icon: AppIcon(
            iconAsset: state.isWishlisted //
                ? Assets.iconHeartFilled
                : Assets.iconHeartEmpty,
            color: state.isWishlisted //
                ? AppTheme.of(context).appColor
                : const Color(0xFFD0D0D0),
          ),
        );
      },
    );
  }
}
