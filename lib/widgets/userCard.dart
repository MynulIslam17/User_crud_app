import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mockapi_test1/models/user_model.dart';

class UserCard extends StatelessWidget {

  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final UserModel user;

  const UserCard({
    super.key,
    required this.onEdit,
    required this.onDelete,
    required this.user
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Card(
        child: Container(
          height: 120,
          width: double.infinity,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CircleAvatar(
                  radius: 33,
                  backgroundImage: NetworkImage(
                  user.avatar ?? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ4YreOWfDX3kK-QLAbAL4ufCPc84ol2MA8Xg&ss",

                  ),
                ),
              ),
              SizedBox(width: 10),

              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                     user.userName ?? "Guest",
                      style: TextStyle(
                        fontSize: 13,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                    Text(
                       user.language!.isNotEmpty ? user.language!.join(" ,") : "No language" ,
                      style: TextStyle(
                        fontSize: 13,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                    Text(
                       user.profile?.age?.toString() ?? "0",
                      style: TextStyle(
                        fontSize: 13,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                    Text(
                      user.profile?.gender?.toString() ?? "Not specified",
                      style: TextStyle(
                        fontSize: 13,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    IconButton(
                      onPressed:onEdit,
                      icon: Icon(Icons.edit, color: Colors.green),
                    ),
                    IconButton(
                      onPressed: onDelete,
                      icon: Icon(Icons.delete),
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}