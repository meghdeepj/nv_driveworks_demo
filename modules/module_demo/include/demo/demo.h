#ifndef GW_MODULE_MODULE_DEMO_H
#define GW_MODULE_MODULE_DEMO_H
#include <memory>

namespace gw_module_module_demo
{

class Demo
{
  public:
    explicit Demo(/* args */);
    ~Demo();

  public:
    // 对外API在此声明
    int function_test();

  private:
    // 对象不可复制
    Demo(const Demo&&);
    Demo& operator=(Demo&&);
    // pImpl惯用法，隐藏私有成员
    class Impl;
    std::unique_ptr<Impl> m_impl;
};

}  // namespace gw_module_module_demo

#endif