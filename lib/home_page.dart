import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mockapi_test1/api_service/Api_controller.dart';
import 'package:mockapi_test1/models/user_model.dart';
import 'package:mockapi_test1/widgets/userCard.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ApiController controller=ApiController();
  bool isLoaded=false;


     var genderList=["Male","Female","Other"];


  final List<String> _languages = ['Bangla', 'English', 'Hindi', 'Urdu'];




     dialogBox({UserModel? user }){

       final TextEditingController nameController=TextEditingController(
         text: user!=null ? user.userName : ""
       );
       final TextEditingController emailController=TextEditingController(
         text:user!=null ? user.email : ""
       );
       final TextEditingController imgController=TextEditingController(
         text: user!=null ? user.avatar : ""
       );
       final TextEditingController ageController=TextEditingController(
         text: user !=null ? user.profile?.age.toString() : ""
       );

    // this part use to select default and also for when editing
       String? selected = genderList.contains(user?.profile?.gender)
           ? user?.profile?.gender
           : null;

       List<String> selectedLanguages = user?.language != null
           ? List<String>.from(user!.language!)
           : [];

      bool isSaving=false;


       showDialog(context: context,
           builder: (context){

             return StatefulBuilder(
               builder: (context,setStateDialog) {
                 return AlertDialog(
                   title: Text(user!=null ?"Update user info" :"Add new User Info",style: TextStyle(fontSize:15,),),
                   content: SingleChildScrollView(
                     child: SizedBox(
                       width: MediaQuery.of(context).size.width * 0.3,
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         mainAxisSize: MainAxisSize.min,
                         children: [
                     
                           TextField(
                             controller: nameController,
                             decoration:InputDecoration(
                               label: Text("UserName")
                             ),
                           ),
                           TextField(
                             controller: emailController,
                             decoration: InputDecoration(
                               label: Text("Email"),
                     
                             ),
                           ),
                           TextField(
                             controller: imgController,
                             maxLines: 2,
                             decoration: InputDecoration(
                               label: Text("Image Url"),
                     
                             ),
                           ),
                           SizedBox(
                             height: 10,
                           ),
                     
                     
                     
                           DropdownButton(
                     
                                value: selected, // can be null when started
                                 hint: Text("Select gender"), // if null then show this text
                               items: genderList.map((gender)=>DropdownMenuItem(
                                   value: gender,
                                 child: Padding(
                                   padding: const EdgeInsets.symmetric(horizontal: 10),
                                   child: Text(gender),
                                 ),
                               )).toList(),
                               onChanged: (String ? newValue){
                                  setStateDialog((){
                                    selected=newValue;
                                  });
                               }
                     
                           ),
                     
                           SizedBox(height: 10,),
                     
                           MultiSelectDialogField<String>(
                     
                             dialogHeight: 300,
                             items: _languages.map((lang) => MultiSelectItem(lang, lang)).toList(),
                             title: Text("Languages"),
                             selectedColor: Colors.blue,
                             buttonText: Text("Select Languages"),
                             initialValue: selectedLanguages,
                             onConfirm: (results) {
                     
                               setStateDialog((){
                                 selectedLanguages=List<String>.from(results);
                               });
                     
                             },
                     
                             chipDisplay: MultiSelectChipDisplay(
                               onTap: (item) {
                                 setState(() {
                                   selectedLanguages.remove(item);
                                 });
                               },
                             ),
                           ),
                     
                           SizedBox(height: 10,),
                           TextField(
                             controller: ageController,
                             keyboardType:TextInputType.number,
                             decoration: InputDecoration(
                               label: Text("age")
                             ),
                           ),
                     
                           SizedBox(height: 20,),
                     
                           // button for save and cancel
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                     
                              TextButton(onPressed: (){
                                Navigator.pop(context);
                     
                     
                              },
                                child: Text("Cancel") ),
                     
                               ElevatedButton(
                                 onPressed: () async{

                                   // show the progressindicator by make it true
                                   setStateDialog((){
                                     isSaving=true;
                                   });

                     
                                   // step1: get all the input from user
                                   String name=nameController.text.trim();
                                   String email=emailController.text.trim();
                                   String imageUrl=imgController.text.trim();
                                   String age=ageController.text.trim();
                     
                                   //step2 validate the input
                     
                              if(name.isEmpty || email.isEmpty|| imageUrl.isEmpty|| age.isEmpty||selected==null ||selectedLanguages.isEmpty){
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill in all required fields")));
                                return;
                              }
                              //step3 convert field to required datatype
                                int userAge= int.tryParse(age)  ?? 0;
                     
                              // step 5 create newUser Object
                               UserModel newUser=UserModel(
                                 userName:name,
                                 email: email,
                                 avatar: imageUrl,
                                 profile: Profile(
                                   age: userAge,
                                   gender: selected
                                 ),
                                 language: selectedLanguages
                     
                               );

                               // when updating add the add to the object
                               if(user!=null){
                                 newUser.id=user.id;
                               }

                               bool success; // a flag value to check

                                   try{

                                 if(user!=null){ // user not null update

                                success  =await controller.updateUser(newUser);

                               }else{ // if user null then create

                                  success=await controller.createUser(newUser);
                               }

                                 // hide the create or update indicator
                                 setStateDialog((){
                                   isSaving=false;
                                 });

                     
                               //step 6 get check the process

                                     if(success){
                                       await controller.fetchUsers();
                                       setState(() {
                     
                                       });
                                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(user!=null ?"successfully update  user": "successfully created new user")));
                                       Navigator.pop(context);
                                     }else{
                                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("something wrong")));
                                     }
                     
                                   }catch (e){
                                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
                                   }
                     
                     
                     
                     
                     
                                 },


                                   child:isSaving ?SizedBox(
                                       height: 18,
                                       width: 18,
                                       child: CircularProgressIndicator(
                                         strokeWidth: 2,
                                         color: Colors.white,
                                       ))
                                       : Text(user!=null ? "update user" : "Create user",style: TextStyle(fontSize: 13),),
                     
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor:Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4)
                                    )
                     
                                  ),
                     
                     
                               )
                     
                     
                             ],
                           )
                     
                     
                     
                         ],
                       ),
                     ),
                   ),
                 );
               }
             );


           });

     }






   bottomSheet(BuildContext context){

     showModalBottomSheet(context: context,

         builder: (context){
           return SizedBox(
             width: double.infinity,
             child: Column(
               mainAxisSize: MainAxisSize.min,
               children: [
                 SizedBox(height: 20,),
                 Text("Are you sure you want to delete?",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                 SizedBox(height: 10,),

                 Row(

                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     ElevatedButton(onPressed: (){},
                         child: Text("Yes"),
                       style: ElevatedButton.styleFrom(
                         backgroundColor: Colors.red,
                         foregroundColor: Colors.white
                       ),
                     ),
                     SizedBox(width: 30,),
                     ElevatedButton(onPressed: (){},
                         child:Text("No"),
                       style: ElevatedButton.styleFrom(
                         backgroundColor: Colors.green,
                         foregroundColor: Colors.white
                       ),
                     )
                   ],
                 ),
                 SizedBox(height: 50,),

               ],
             ),

           );
         }
         );
   }


  fetchData() async{
    try{
     await controller.fetchUsers();
     setState(() {

     });

    }catch (e){
      throw Exception("$e");
    }finally{

      setState(() {
        isLoaded=true;
      });

    }



  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     fetchData(); // calls to fetch data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("MockApi",style: TextStyle(color:Colors.white),), backgroundColor: Colors.black),

      body:!isLoaded ? Center(child: CircularProgressIndicator())

        :  controller.users.isEmpty ? Center(child:Text("No users found"),)

        :  RefreshIndicator(
            onRefresh: () async{
              await controller.fetchUsers();
              setState(() {

              });

            },
          child: ListView.builder(
          itemBuilder: (context, index) {

              final user=  controller.users[index]; // get the info of one user

            return UserCard(
              user: user, // pass the info of one user
              onEdit: (){
                dialogBox(user:user);

              },
                onDelete: () async {
                  try {
                    bool success = await controller.deleteUser(user.id!);
                    if (success) {
                      await fetchData();
                      setState(() {

                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Data deleted")),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Can't delete")),
                      );
                    }
                  } catch (e) {
                    debugPrint("Error deleting user: $e");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Something went wrong")),
                    );
                  }
                }


            );
          },

          itemCount: controller.users.length,
                ),
        ),

      floatingActionButton: FloatingActionButton(

          onPressed: (){

            dialogBox();
          },
        backgroundColor:Colors.red,
        child:Icon(Icons.add,color: Colors.white,),
        foregroundColor: Colors.black,

      ),




    );
  }
}


