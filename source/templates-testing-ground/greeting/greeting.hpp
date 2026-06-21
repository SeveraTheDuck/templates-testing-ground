/**
 * @file greeting.hpp
 * @brief Greeting utilities for templates-testing-ground.
 */

#pragma once

#include <string>
#include <string_view>

namespace templates_testing_ground {

/**
 * @brief Builds a greeting message for the given name.
 *
 * @param name Name to greet.
 * @return A greeting of the form "Hello, <name>!".
 */
[[nodiscard]] std::string Greeting(std::string_view name);

}  // namespace templates_testing_ground
