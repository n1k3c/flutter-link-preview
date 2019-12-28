# link_preview

[Flutter plugin](https://pub.dev/packages/link_preview) for previewing links (such as title, description, image). This is a port of [Android](https://github.com/LeonardoCardoso/Android-Link-Preview) and [iOS](https://github.com/LeonardoCardoso/SwiftLinkPreview) library. For now, it is not recommended to use this plugin in production.

## Usage

```
Future<void> getLinks() async {
      try {
            PreviewResponse previewResponse = await LinkPreview.getPreview('https://google.com');
            _previewData(previewResponse);
      
            PreviewResponse previewResponse2 = await LinkPreview.getPreview('https://facebook.com');
            _previewData(previewResponse2);
      
            PreviewResponse previewResponse3 = await LinkPreview.getPreview('https://amazon.com');
            _previewData(previewResponse3);
          } on PlatformException {
            print('Error occured!!');
          }
  }

  _previewData(PreviewResponse previewResponse) {
    if (previewResponse.status == PreviewStatus.success) {
          print('===============================================');
          print('Received status: ${previewResponse.status}');
          print('Received title: ${previewResponse.title}');
          print('Received description: ${previewResponse.description}');
          print('Received image: ${previewResponse.image}');
          print('Received url: ${previewResponse.url}');
          print('Received final url: ${previewResponse.finalUrl}');
          print('Received cannonical url: ${previewResponse.cannonicalUrl}');
          print('Received html code: ${previewResponse.htmlCode}');
          print('Received row: ${previewResponse.row}');
          print('===============================================');
        } else if (previewResponse.status == PreviewStatus.wrongUrlError) {
          print('===============================================');
          print('Received status: ${previewResponse.status}');
          print('Wrong URL');
          print('===============================================');
        } else if (previewResponse.status == PreviewStatus.parsingError) {
          print('===============================================');
          print('Received status: ${previewResponse.status}');
          print('Parsing URL error');
          print('===============================================');
        } else {
          print('===============================================');
          print('Received status: ${previewResponse.status}');
          print('Other error');
          print('===============================================');
        }
  }
```


