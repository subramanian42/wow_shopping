import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wow_shopping/app/assets.dart';
import 'package:wow_shopping/app/theme.dart';
import 'package:wow_shopping/backend/wishlist_repo.dart';
import 'package:wow_shopping/features/wishlist/provider/select_item_notifier.dart';

import 'package:wow_shopping/features/wishlist/widgets/wishlist_item.dart';

import 'package:wow_shopping/widgets/app_button.dart';
import 'package:wow_shopping/widgets/common.dart';
import 'package:wow_shopping/widgets/top_nav_bar.dart';

@immutable
class WishlistPage extends ConsumerStatefulWidget {
  const WishlistPage({super.key});

  @override
  ConsumerState<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends ConsumerState<WishlistPage> {
  @override
  Widget build(BuildContext context) {
    final selectedItems = ref.watch(selectItemsState);
    final wishlistItems = ref.watch(wishlistRepoProvider);
    return SizedBox.expand(
      child: Material(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TopNavBar(
              title: const Text('Wishlist'),
              actions: [
                TextButton(
                  onPressed: () =>
                      ref.read(selectItemsState.notifier).toggleSelectAll(),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Select All'),
                ),
              ],
            ),
            Expanded(
              child: MediaQuery.removeViewPadding(
                context: context,
                removeTop: true,
                child: ListView.builder(
                  padding: verticalPadding12,
                  itemCount: wishlistItems.currentWishlistItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = wishlistItems.currentWishlistItems[index];
                    return Padding(
                      padding: verticalPadding12,
                      child: WishlistItem(
                        item: item,
                        onPressed: (item) {
                          // FIXME: navigate to product details
                        },
                        selected: selectedItems.contains(item.id),
                        onToggleSelection:
                            ref.read(selectItemsState.notifier).setSelected,
                      ),
                    );
                  },
                ),
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn,
              alignment: Alignment.topCenter,
              child: Align(
                alignment: Alignment.topCenter,
                heightFactor: selectedItems.isEmpty ? 0.0 : 1.0,
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    color: appLightGreyColor,
                    border: Border(
                      top: BorderSide(color: appDividerColor, width: 2.0),
                    ),
                  ),
                  child: Padding(
                    padding: allPadding24,
                    child: Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            onPressed: ref
                                .read(selectItemsState.notifier)
                                .removeSelected,
                            label: 'Remove',
                            iconAsset: Assets.iconRemove,
                          ),
                        ),
                        horizontalMargin16,
                        Expanded(
                          child: AppButton(
                            onPressed: () {
                              // FIXME: implement Buy Now button
                            },
                            label: 'Buy now',
                            iconAsset: Assets.iconBuy,
                            style: AppButtonStyle.highlighted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
