#include "module_demo/module_demo.h"
#include <iostream>

namespace team_demo_module_demo
{
// 先定义Impl
class Demo::Impl
{
  public:
    ~Impl()
    {
    }

    void initialization()
    {
        std::cout << "Hello, Demo!" << std::endl;
    }

    int function_test()
    {
      return 1;
    }

  private:
};

Demo::Demo(/* args */) : m_impl(new Impl())
{
    m_impl->initialization();
}

Demo::~Demo()
{
}

int Demo::function_test()
{
  return m_impl->function_test();
}

}  // namespace team_demo_module_demo