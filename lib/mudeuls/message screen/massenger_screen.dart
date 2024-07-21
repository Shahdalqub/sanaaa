import "package:flutter/material.dart";

class MessengerDesighn extends StatelessWidget
{


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        titleSpacing: 20.0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20.0,
              backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1530092285049-1c42085fd395?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
            ),
            SizedBox(
              width: 15.0,
            ),

          ],
        ),
        actions: [
          IconButton(
              onPressed: (){},
              icon:CircleAvatar(
                radius: 15.0,
                backgroundColor: Colors.blue,
                child: Icon(
                  Icons.camera_alt,
                  size: 16.0,
                  color: Colors.white,
                ),
              )
          ),
          IconButton(
              onPressed: (){},
              icon:CircleAvatar(
                radius: 15.0,
                backgroundColor: Colors.blue,
                child: Icon(
                  Icons.edit,
                  size: 16.0,
                  color: Colors.white,
                ),
              )
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius:BorderRadius.circular(
                    5.0,
                  ),
                  color: Colors.grey[300],
                ),
                padding:  EdgeInsets.all(5.0),

                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                    ),
                    SizedBox(
                      width:15.0 ,
                    ),
                    Text('Search'),

                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                height: 120.0,
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder:(context,index)=>buildStoryItem(),
                  separatorBuilder: (context,index)=>SizedBox(width: 20.0,),
                  itemCount:5 ,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                //  scrollDirection: Axis.vertical,
                itemBuilder:(context,index)=>buildChatItem(),
                separatorBuilder: (context,index)=>SizedBox(height: 20.0,),
                itemCount:15 ,
              ),
              /*SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      width: 60.0,
                      child: Column(

                        children: [
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                radius: 30.0,
                                backgroundImage: NetworkImage(
                                    'https://images.unsplash.com/photo-1530092285049-1c42085fd395?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                              ),

                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  bottom: 5.0,
                                  end: 3.0,
                                ),
                                child: CircleAvatar(
                                  radius: 7.0,
                                  backgroundColor:Colors.red ,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height:20.0 ,
                          ),
                          Text(
                              'Shahd Qub',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Container(
                      width: 60.0,
                      child: Column(

                        children: [
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                radius: 30.0,
                                backgroundImage: NetworkImage(
                                    'https://images.unsplash.com/photo-1530092285049-1c42085fd395?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                              ),

                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  bottom: 5.0,
                                  end: 3.0,
                                ),
                                child: CircleAvatar(
                                  radius: 7.0,
                                  backgroundColor:Colors.red ,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height:20.0 ,
                          ),
                          Text(
                            'Shahd Qub',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Container(
                      width: 60.0,
                      child: Column(

                        children: [
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                radius: 30.0,
                                backgroundImage: NetworkImage(
                                    'https://images.unsplash.com/photo-1530092285049-1c42085fd395?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                              ),

                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  bottom: 5.0,
                                  end: 3.0,
                                ),
                                child: CircleAvatar(
                                  radius: 7.0,
                                  backgroundColor:Colors.red ,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height:20.0 ,
                          ),
                          Text(
                            'Shahd Qub',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Container(
                      width: 60.0,
                      child: Column(

                        children: [
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                radius: 30.0,
                                backgroundImage: NetworkImage(
                                    'https://images.unsplash.com/photo-1530092285049-1c42085fd395?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                              ),

                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  bottom: 5.0,
                                  end: 3.0,
                                ),
                                child: CircleAvatar(
                                  radius: 7.0,
                                  backgroundColor:Colors.red ,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height:20.0 ,
                          ),
                          Text(
                            'Shahd Qub',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Container(
                      width: 60.0,
                      child: Column(

                        children: [
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                radius: 30.0,
                                backgroundImage: NetworkImage(
                                    'https://images.unsplash.com/photo-1530092285049-1c42085fd395?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                              ),

                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  bottom: 5.0,
                                  end: 3.0,
                                ),
                                child: CircleAvatar(
                                  radius: 7.0,
                                  backgroundColor:Colors.red ,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height:20.0 ,
                          ),
                          Text(
                            'Shahd Qub',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Container(
                      width: 60.0,
                      child: Column(

                        children: [
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                radius: 30.0,
                                backgroundImage: NetworkImage(
                                    'https://images.unsplash.com/photo-1530092285049-1c42085fd395?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                              ),

                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  bottom: 5.0,
                                  end: 3.0,
                                ),
                                child: CircleAvatar(
                                  radius: 7.0,
                                  backgroundColor:Colors.red ,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height:20.0 ,
                          ),
                          Text(
                            'Shahd Qub',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Container(
                      width: 60.0,
                      child: Column(

                        children: [
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                radius: 30.0,
                                backgroundImage: NetworkImage(
                                    'https://images.unsplash.com/photo-1530092285049-1c42085fd395?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                              ),

                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  bottom: 5.0,
                                  end: 3.0,
                                ),
                                child: CircleAvatar(
                                  radius: 7.0,
                                  backgroundColor:Colors.red ,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height:20.0 ,
                          ),
                          Text(
                            'Shahd Qub',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                  ],
                ),
              ),*/
              /*   Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                radius: 30.0,
                                backgroundImage: NetworkImage(
                                    'https://images.unsplash.com/photo-1530092285049-1c42085fd395?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                              ),

                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  bottom: 5.0,
                                  end: 3.0,
                                ),
                                child: CircleAvatar(
                                  radius: 7.0,
                                  backgroundColor:Colors.red ,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                          width:  20.0,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Shahd Qub',
                                  maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'hello word',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0,
                                      ),
                                      child: Container(
                                        width:7.0 ,
                                        height: 7.0,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          shape: BoxShape.circle,

                                        ),
                                      ),
                                    ),
                                    Text(
                                      '02:00 pm',
                                    )
                                  ],

                                ),

                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        children: [
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                radius: 30.0,
                                backgroundImage: NetworkImage(
                                    'https://images.unsplash.com/photo-1530092285049-1c42085fd395?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                              ),

                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  bottom: 5.0,
                                  end: 3.0,
                                ),
                                child: CircleAvatar(
                                  radius: 7.0,
                                  backgroundColor:Colors.red ,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width:  20.0,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Shahd Qub',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'hello word',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0,
                                      ),
                                      child: Container(
                                        width:7.0 ,
                                        height: 7.0,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          shape: BoxShape.circle,

                                        ),
                                      ),
                                    ),
                                    Text(
                                      '02:00 pm',
                                    )
                                  ],

                                ),

                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        children: [
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                radius: 30.0,
                                backgroundImage: NetworkImage(
                                    'https://images.unsplash.com/photo-1530092285049-1c42085fd395?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                              ),

                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  bottom: 5.0,
                                  end: 3.0,
                                ),
                                child: CircleAvatar(
                                  radius: 7.0,
                                  backgroundColor:Colors.red ,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width:  20.0,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Shahd Qub',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'hello word',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0,
                                      ),
                                      child: Container(
                                        width:7.0 ,
                                        height: 7.0,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          shape: BoxShape.circle,

                                        ),
                                      ),
                                    ),
                                    Text(
                                      '02:00 pm',
                                    )
                                  ],

                                ),

                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        children: [
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                radius: 30.0,
                                backgroundImage: NetworkImage(
                                    'https://images.unsplash.com/photo-1530092285049-1c42085fd395?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                              ),

                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  bottom: 5.0,
                                  end: 3.0,
                                ),
                                child: CircleAvatar(
                                  radius: 7.0,
                                  backgroundColor:Colors.red ,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width:  20.0,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Shahd Qub',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'hello word',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0,
                                      ),
                                      child: Container(
                                        width:7.0 ,
                                        height: 7.0,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          shape: BoxShape.circle,

                                        ),
                                      ),
                                    ),
                                    Text(
                                      '02:00 pm',
                                    )
                                  ],

                                ),

                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        children: [
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                radius: 30.0,
                                backgroundImage: NetworkImage(
                                    'https://images.unsplash.com/photo-1530092285049-1c42085fd395?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                              ),

                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  bottom: 5.0,
                                  end: 3.0,
                                ),
                                child: CircleAvatar(
                                  radius: 7.0,
                                  backgroundColor:Colors.red ,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width:  20.0,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Shahd Qub',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'hello word',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0,
                                      ),
                                      child: Container(
                                        width:7.0 ,
                                        height: 7.0,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          shape: BoxShape.circle,

                                        ),
                                      ),
                                    ),
                                    Text(
                                      '02:00 pm',
                                    )
                                  ],

                                ),

                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        children: [
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                radius: 30.0,
                                backgroundImage: NetworkImage(
                                    'https://images.unsplash.com/photo-1530092285049-1c42085fd395?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                              ),

                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  bottom: 5.0,
                                  end: 3.0,
                                ),
                                child: CircleAvatar(
                                  radius: 7.0,
                                  backgroundColor:Colors.red ,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width:  20.0,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Shahd Qub',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'hello word',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0,
                                      ),
                                      child: Container(
                                        width:7.0 ,
                                        height: 7.0,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          shape: BoxShape.circle,

                                        ),
                                      ),
                                    ),
                                    Text(
                                      '02:00 pm',
                                    )
                                  ],

                                ),

                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        children: [
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                radius: 30.0,
                                backgroundImage: NetworkImage(
                                    'https://images.unsplash.com/photo-1530092285049-1c42085fd395?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                              ),

                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  bottom: 5.0,
                                  end: 3.0,
                                ),
                                child: CircleAvatar(
                                  radius: 7.0,
                                  backgroundColor:Colors.red ,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width:  20.0,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Shahd Qub',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'hello word',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0,
                                      ),
                                      child: Container(
                                        width:7.0 ,
                                        height: 7.0,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          shape: BoxShape.circle,

                                        ),
                                      ),
                                    ),
                                    Text(
                                      '02:00 pm',
                                    )
                                  ],

                                ),

                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        children: [
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                radius: 30.0,
                                backgroundImage: NetworkImage(
                                    'https://images.unsplash.com/photo-1530092285049-1c42085fd395?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                              ),

                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  bottom: 5.0,
                                  end: 3.0,
                                ),
                                child: CircleAvatar(
                                  radius: 7.0,
                                  backgroundColor:Colors.red ,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width:  20.0,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Shahd Qub',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'hello word',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0,
                                      ),
                                      child: Container(
                                        width:7.0 ,
                                        height: 7.0,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          shape: BoxShape.circle,

                                        ),
                                      ),
                                    ),
                                    Text(
                                      '02:00 pm',
                                    )
                                  ],

                                ),

                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        children: [
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                radius: 30.0,
                                backgroundImage: NetworkImage(
                                    'https://images.unsplash.com/photo-1530092285049-1c42085fd395?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                              ),

                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  bottom: 5.0,
                                  end: 3.0,
                                ),
                                child: CircleAvatar(
                                  radius: 7.0,
                                  backgroundColor:Colors.red ,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width:  20.0,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Shahd Qub',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'hello word',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0,
                                      ),
                                      child: Container(
                                        width:7.0 ,
                                        height: 7.0,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          shape: BoxShape.circle,

                                        ),
                                      ),
                                    ),
                                    Text(
                                      '02:00 pm',
                                    )
                                  ],

                                ),

                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        children: [
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                radius: 30.0,
                                backgroundImage: NetworkImage(
                                    'https://images.unsplash.com/photo-1530092285049-1c42085fd395?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                              ),

                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  bottom: 5.0,
                                  end: 3.0,
                                ),
                                child: CircleAvatar(
                                  radius: 7.0,
                                  backgroundColor:Colors.red ,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width:  20.0,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Shahd Qub',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'hello word',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0,
                                      ),
                                      child: Container(
                                        width:7.0 ,
                                        height: 7.0,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          shape: BoxShape.circle,

                                        ),
                                      ),
                                    ),
                                    Text(
                                      '02:00 pm',
                                    )
                                  ],

                                ),

                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        children: [
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                radius: 30.0,
                                backgroundImage: NetworkImage(
                                    'https://images.unsplash.com/photo-1530092285049-1c42085fd395?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                              ),

                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  bottom: 5.0,
                                  end: 3.0,
                                ),
                                child: CircleAvatar(
                                  radius: 7.0,
                                  backgroundColor:Colors.red ,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width:  20.0,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Shahd Qub',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'hello word',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0,
                                      ),
                                      child: Container(
                                        width:7.0 ,
                                        height: 7.0,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          shape: BoxShape.circle,

                                        ),
                                      ),
                                    ),
                                    Text(
                                      '02:00 pm',
                                    )
                                  ],

                                ),

                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        children: [
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                radius: 30.0,
                                backgroundImage: NetworkImage(
                                    'https://images.unsplash.com/photo-1530092285049-1c42085fd395?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                              ),

                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  bottom: 5.0,
                                  end: 3.0,
                                ),
                                child: CircleAvatar(
                                  radius: 7.0,
                                  backgroundColor:Colors.red ,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width:  20.0,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Shahd Qub',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'hello word',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0,
                                      ),
                                      child: Container(
                                        width:7.0 ,
                                        height: 7.0,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          shape: BoxShape.circle,

                                        ),
                                      ),
                                    ),
                                    Text(
                                      '02:00 pm',
                                    )
                                  ],

                                ),

                              ],
                            ),
                          )
                        ],
                      ),

                    ],
                  ),
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
  Widget buildChatItem()=> Row(
    children: [
      Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          CircleAvatar(
            radius: 30.0,
            backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1530092285049-1c42085fd395?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
          ),

          Padding(
            padding: const EdgeInsetsDirectional.only(
              bottom: 5.0,
              end: 3.0,
            ),
            child: CircleAvatar(
              radius: 7.0,
              backgroundColor:Colors.red ,
            ),
          ),
        ],
      ),
      SizedBox(
        width:  20.0,
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Shahd Qub',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'hello word',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                  ),
                  child: Container(
                    width:7.0 ,
                    height: 7.0,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,

                    ),
                  ),
                ),
                Text(
                  '02:00 pm',
                )
              ],

            ),

          ],
        ),
      )
    ],
  );
  Widget buildStoryItem()=>Container(
    width: 60.0,
    child: Column(

      children: [
        Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            CircleAvatar(
              radius: 30.0,
              backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1530092285049-1c42085fd395?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
            ),

            Padding(
              padding: const EdgeInsetsDirectional.only(
                bottom: 5.0,
                end: 3.0,
              ),
              child: CircleAvatar(
                radius: 7.0,
                backgroundColor:Colors.red ,
              ),
            ),
          ],
        ),
        SizedBox(
          height:20.0 ,
        ),
        Text(
          'Shahd Qub',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );

}
