#pragma once

#include <string>
#include <string_view>

namespace templates_testing_ground {

// Returns a greeting for the given name. Replace with your own API.
[[nodiscard]] std::string Greeting(std::string_view name);

}  // namespace templates_testing_ground
