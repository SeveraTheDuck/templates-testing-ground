#include <templates-testing-ground/greeting/greeting.hpp>

#include <string>

namespace templates_testing_ground {

std::string Greeting(std::string_view name) {
  return "Hello, " + std::string{name} + "!";
}

}  // namespace templates_testing_ground
