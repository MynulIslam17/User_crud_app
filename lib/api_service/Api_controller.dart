import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mockapi_test1/models/user_model.dart';
import 'package:mockapi_test1/utils/urls.dart';


   class ApiController{

    List<UserModel>users=[];
      
      Future<void> fetchUsers() async{
        
         final uri=Uri.parse(ApiUrls.getUsers);

         try{
            final response= await http.get(uri);

            if(response.statusCode==200){ // check status code

               final List<dynamic> jsonArray=jsonDecode(response.body); // return list or map

               users= jsonArray.map((object)=>UserModel.fromJson(object)).toList() ;

            }else{ // if not get success status code
               print("Failed to load users. Status code: ${response.statusCode}");
            }

         }
         catch (e){
            rethrow;
         }

         
      }


      Future<bool> deleteUser(String id) async{

         final uri=Uri.parse(ApiUrls.deleteUserById(id));

         try{

           final response=await http.delete(uri);

           if(response.statusCode == 200){
             await fetchUsers();
             return true;
           }else{
             print("can't delete ${response.statusCode}");
             return false;
           }

         }catch (e){
           rethrow;
         }



      }




      Future<bool> createUser(UserModel user) async{

        final uri = Uri.parse(ApiUrls.createUser);

        try{

          final response= await http.post(
              uri,
              headers: {"Content-Type":"application/json",},
              body: jsonEncode(user.toJson())

          );

          if(response.statusCode==201){
            await fetchUsers();
            return true;
          }else{
            return false;
          }


        }catch (e){
          rethrow;
        }







      }


      Future<bool> updateUser(UserModel user) async{

        final uri=Uri.parse(ApiUrls.updateUserById(user.id!));

        try{

          final response= await http.put(uri,

              headers: {"Content-Type":"application/json"},
              body: jsonEncode(user.toJson())
          );

          if(response.statusCode==200){
            await fetchUsers();
            return true;
          }else{
            return false;
          }

        }catch (e){
          rethrow;
        }



      }

      
      


   }