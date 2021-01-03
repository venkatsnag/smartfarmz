class HttpException implements Exception{
final String message;
HttpException(this.message);

@override
String toSting(){
  return message;
}
}