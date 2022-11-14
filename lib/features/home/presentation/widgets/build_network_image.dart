import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_colors.dart';

class BuildNetworkImage extends StatelessWidget {
  final String image;
  const BuildNetworkImage(this.image, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(image.isEmpty){
      return const _BuildErrorWidget();
    }

    return CachedNetworkImage(
      imageUrl: image,
      placeholderFadeInDuration: const Duration(milliseconds: 450),
      fadeOutDuration:  const Duration(milliseconds: 450),
      placeholder: (context, url) => Lottie.asset('assets/lottie/loading_anim.json',fit: BoxFit.contain),
      errorWidget: (context, url, error) => const _BuildErrorWidget(),
    );
  }
}

class _BuildErrorWidget extends StatelessWidget {
  const _BuildErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const FractionallySizedBox(
        widthFactor: 0.42,
        heightFactor: 0.42,
        child: FittedBox(
            child: Icon(
              Icons.image_outlined,
              color: AppColors.semiBlack,
        )));
  }
}

