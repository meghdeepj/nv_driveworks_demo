#include <gtest/gtest.h>
#include "demo/demo.h"

TEST(demo_ini, demo)
{
    gw_module_module_demo::Demo demo;
    ASSERT_EQ(1, demo.function_test());
}

int main(int argc, char** argv)
{
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}