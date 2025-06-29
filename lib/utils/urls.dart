
 class ApiUrls{

  static String baseUrl="https://685cec96769de2bf085e72f6.mockapi.io";

  static String  getUsers="$baseUrl/api/v1/Users";
  static String  createUser="$baseUrl/api/v1/Users";
  static String deleteUserById(String id) =>"$baseUrl/api/v1/Users/$id";
  static String updateUserById(String id)  => "$baseUrl/api/v1/Users/$id";






 }