#include <templates-testing-ground/greeting/greeting.hpp>

#include <gtest/gtest.h>

namespace {

TEST(greeting, returns_hello) {
  EXPECT_EQ(templates_testing_ground::Greeting("world"), "Hello, world!");
}

}  // namespace
