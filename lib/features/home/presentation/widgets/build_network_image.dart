import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class BuildNetworkImage extends StatelessWidget {
  final String image;
  const BuildNetworkImage(this.image, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(image.isEmpty){
      return  const _BuildErrorWidget();
    }

    return Image.network(
      image,
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return FractionallySizedBox(
            widthFactor: 0.22,
            heightFactor: 0.22,
            child: FittedBox(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                      : null,
                )));
      },
      errorBuilder: (context, error, stackTrace) {
        return const _BuildErrorWidget();
      },
    );
  }
}

class _BuildErrorWidget extends StatelessWidget {
  const _BuildErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const FractionallySizedBox(
        widthFactor: 0.4,
        heightFactor: 0.4,
        child: FittedBox(
            child: Icon(
              Icons.image_outlined,
              color: AppColors.semiBlack,
        )));
  }
}

