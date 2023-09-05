import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:wow_shopping/app/assets.dart';
import 'package:wow_shopping/app/theme.dart';
import 'package:wow_shopping/features/product_details/models/product_proxy.dart';
import 'package:wow_shopping/widgets/app_icon.dart';

@immutable
class WishlistButton extends WatchingStatefulWidget {
  const WishlistButton({
    super.key,
    required this.item,
  });

  final ProductProxy item;

  @override
  State<WishlistButton> createState() => _WishlistButtonState();
}

class _WishlistButtonState extends State<WishlistButton> {
  // void _onTogglePressed(bool value) {
  //   if (value) {
  //     wishlistRepo.addToWishlist(widget.item.id);
  //   } else {
  //     wishlistRepo.removeToWishlist(widget.item.id);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final onWishList = watch(widget.item).onWishList;
    return IconButton(
      onPressed: widget.item.toggleWishListCommand,
      icon: AppIcon(
        iconAsset: onWishList //
            ? Assets.iconHeartFilled
            : Assets.iconHeartEmpty,
        color: onWishList //
            ? AppTheme.of(context).appColor
            : const Color(0xFFD0D0D0),
      ),
    );
    // return StreamBuilder<bool>(
    //   initialData: wishlistRepo.isInWishlist(widget.item),
    //   stream: wishlistRepo.streamIsInWishlist(widget.item),
    //   builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
    //     final value = snapshot.requireData;
    //     return IconButton(
    //       onPressed: () => _onTogglePressed(!value),
    //       icon: AppIcon(
    //         iconAsset: value //
    //             ? Assets.iconHeartFilled
    //             : Assets.iconHeartEmpty,
    //         color: value //
    //             ? AppTheme.of(context).appColor
    //             : const Color(0xFFD0D0D0),
    //       ),
    //     );
    //   },
    // );
  }
}
