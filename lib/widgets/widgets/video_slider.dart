import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class VideoSlider extends StatefulWidget {
   VideoSlider({Key? key,}) : super(key: key,);


  @override
  State<VideoSlider> createState() => _VideoSliderState();
}

class _VideoSliderState extends State<VideoSlider> {
  VideoPlayerController? videoPlayerController;
  @override
  void initState() {
    // TODO: implement initState
    Uri uri = Uri.parse("http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4");
    String typeString = uri.path.substring(uri.path.length - 3).toLowerCase();
    if (typeString == 'mp4') {
      videoPlayerController = VideoPlayerController.network("http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4");
      videoPlayerController!.initialize();
      videoPlayerController!.setLooping(false);
      videoPlayerController!.play();
    }
    super.initState();
  }
  bool? isPlaying ;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    videoPlayerController?.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Uri uri = Uri.parse("http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4");
    String typeString = uri.path.substring(uri.path.length - 3).toLowerCase();
    return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(1)),
// height: 180,
// width: MediaQuery.of(context).size.width,
        child: Stack(
          fit: StackFit.expand,
          children: [
            AspectRatio(
              aspectRatio: videoPlayerController!.value.aspectRatio,
              child: VideoPlayer(videoPlayerController!),
            ),
            Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: InkWell(
                    onTap: (){
                      if (videoPlayerController!.value.isPlaying){
                        videoPlayerController!.pause();
                        isPlaying =false ;
                      }else{
                        isPlaying = true;
                        videoPlayerController!.play();
                      }
                      setState(() {

                      });
                    },
                    child: Icon(isPlaying ?? true ?Icons.pause  : Icons.play_arrow , color: Colors.white)))
          ],),
    );
  }
}
