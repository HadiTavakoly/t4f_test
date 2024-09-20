import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:t4f_test/controller/controller.dart';
import 'package:t4f_test/view/details.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.put(HomeController());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('t4f'),
      ),
      body: Center(
        child: Obx(
          () => homeController.isLoading.value
              ? Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  period: const Duration(seconds: 2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CarouselSlider.builder(
                        itemCount: 5,
                        itemBuilder: (context, index, realIndex) {
                          return Container(
                            width: Get.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          enlargeCenterPage: true,
                          enlargeStrategy: CenterPageEnlargeStrategy.scale,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const AnimatedSmoothIndicator(
                        activeIndex: 0,
                        count: 10,
                        effect: ExpandingDotsEffect(
                          dotHeight: 10,
                          dotWidth: 10,
                        ),
                      ),
                    ],
                  ),
                )
              : homeController.products == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          homeController.error.value,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        GestureDetector(
                          onTap: () async {
                            await homeController.getProducts();
                          },
                          child: Container(
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.refresh_rounded,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Try again',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CarouselSlider.builder(
                          itemCount: homeController.products!.length,
                          itemBuilder: (context, index, realIndex) {
                            return GestureDetector(
                              onTap: () {
                                Get.to(
                                  duration: const Duration(seconds: 1),
                                  () => Details(
                                    product: homeController.products![index],
                                  ),
                                );
                                homeController.saveProductId(
                                    homeController.products![index].id);
                              },
                              child: Hero(
                                tag: homeController.products![index].id,
                                child: Material(
                                  type: MaterialType.transparency,
                                  child: Stack(
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: homeController
                                            .products![index].image,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        placeholder: (context, url) => Center(
                                          child: Shimmer.fromColors(
                                            baseColor: Colors.grey[300]!,
                                            highlightColor: Colors.grey[100]!,
                                            period: const Duration(seconds: 2),
                                            child: Container(
                                              width: Get.width,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Center(
                                          child: Text(
                                            'Error loading photo',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          gradient: const LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.transparent,
                                              Colors.transparent,
                                              // Colors.black,
                                              Colors.black87,
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Container(
                                          padding: const EdgeInsets.all(15),
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(20),
                                                bottomLeft: Radius.circular(20),
                                              ),
                                              color: Colors.deepPurple),
                                          child: Text(
                                            homeController.products![index].id,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 20,
                                        left: 20,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              homeController
                                                  .products![index].title,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              homeController
                                                  .products![index].city,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          options: CarouselOptions(
                            autoPlay: true,
                            reverse: true,
                            enlargeCenterPage: true,
                            enlargeStrategy: CenterPageEnlargeStrategy.scale,
                            autoPlayInterval: const Duration(
                              seconds: 5,
                            ),
                            autoPlayAnimationDuration: const Duration(
                              seconds: 2,
                            ),
                            onPageChanged: (index, reason) {
                              homeController.activeIndex.value = index;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        AnimatedSmoothIndicator(
                          activeIndex: homeController.activeIndex.value,
                          count: homeController.products!.length,
                          effect: const ExpandingDotsEffect(
                            dotHeight: 10,
                            dotWidth: 10,
                          ),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}
