#include<iostream>
#include <nlohmann/json.hpp>

// for convenience
using json = nlohmann::json;
 
int main(int argc, char *argv[]){
   json j = json::parse("{ \"text\": \"Hello World!\" }");
   std::cout << j["text"].get<std::string>() << std::endl;
   return 0;
}
