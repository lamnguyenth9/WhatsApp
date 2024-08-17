import 'package:equatable/equatable.dart';

class StatusImageEntity extends Equatable{
  final String? url;
  final String?type;
  final List<String>? viewers;

  StatusImageEntity({this.url,this.type,this.viewers});
  factory StatusImageEntity.fromJson(Map<String,dynamic> json){
     return StatusImageEntity(
      url: json['url'],
      type: json['type'],
      viewers: List.from(json['viewers'])
     );
  }
  Map<String,dynamic> toJson()=>{
    "url":url,
    "type":type,
    "viewers":viewers
  };
  
  @override
  // TODO: implement props
  List<Object?> get props => [
    url,type,viewers
  ];
  
}