/////////////////////////////////////////////////////////////////////////////////////////
//
// Notice
// ALL NVIDIA DESIGN SPECIFICATIONS AND CODE ("MATERIALS") ARE PROVIDED "AS IS" NVIDIA MAKES
// NO REPRESENTATIONS, WARRANTIES, EXPRESSED, IMPLIED, STATUTORY, OR OTHERWISE WITH RESPECT TO
// THE MATERIALS, AND EXPRESSLY DISCLAIMS ANY IMPLIED WARRANTIES OF NONINFRINGEMENT,
// MERCHANTABILITY, OR FITNESS FOR A PARTICULAR PURPOSE.
//
// NVIDIA CORPORATION & AFFILIATES assumes no responsibility for the consequences of use of such
// information or for any infringement of patents or other rights of third parties that may
// result from its use. No license is granted by implication or otherwise under any patent
// or patent rights of NVIDIA CORPORATION & AFFILIATES. No third party distribution is allowed unless
// expressly authorized by NVIDIA. Details are subject to change without notice.
// This code supersedes and replaces all information previously supplied.
// NVIDIA CORPORATION & AFFILIATES products are not authorized for use as critical
// components in life support devices or systems without express written approval of
// NVIDIA CORPORATION & AFFILIATES.
//
// SPDX-FileCopyrightText: Copyright (c) 2016-2021 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
// SPDX-License-Identifier: LicenseRef-NvidiaProprietary
//
// NVIDIA CORPORATION, its affiliates and licensors retain all intellectual
// property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from NVIDIA CORPORATION or
// its affiliates is strictly prohibited.
//
// Parser Version: 0.7.5
// SSM Version:    0.9.1
//
/////////////////////////////////////////////////////////////////////////////////////////

/**
* The following file has been generated by SSM's parser.
* Please do not manually modify the files
*/

#pragma once

#include <sm1/SSMNames.hpp>
#include <ssm/SMBaseClass.hpp>
#include <ssm/SSMHistogram.hpp>
#include <sm1/SSMMappings.hpp>

namespace SystemStateManager
{

namespace SM1
{

extern bool setupHierarchy(StateMachineVector& smv, StateMachinePtr& hPtr);

class SSM : public SMBaseClass
{
public:
    ~SSM() {};
    SSM()
    {
        name = "SSM";
        initLockSteppedCommands();
    }
    virtual void initStateMachine() {};
    virtual void ENTER() {}
    virtual void EXIT() {}
    virtual void PRE_INIT() {}
    virtual void INIT() {}
    virtual void POST_INIT() {}
    virtual void PRE_READY() {}
    virtual void READY() {}
    virtual void Degrade() {};
    virtual void NormalOperation() {};
    virtual void Standby() {};
    virtual void UrgentOperation() {};
    virtual void preSwitchHandler() {}
    virtual void postSwitchHandler() {}
    void executeStateMachine() override;
    bool setupTreeHierarchy(StateMachineVector& smv, StateMachinePtr& hPtr) override;
    void documentStateChangeExternally() override;
    void initialize() override;
    bool executeLockedCommand(SystemStateManager::SM1::LockSteppedCommands command);
    bool changeState(SSMStates e);
    int sendDataByID(StateMachines e, void *data, int datalen, std::string dataStructID);
    SSMStates getState();

    StateMachines stateMachineId {StateMachines::SSM};
    // API to register LockedStepCommands
    bool registerLockedCommand(SystemStateManager::SM1::LockSteppedCommands command, SSMFunctionHandler ptr);

    bool getUserSpecificData(UserDataPkt &pkt);

private:
    void printClientHistogram();
    void initLockSteppedCommands();
    SSMHistogram runnableHist{};

};

}
}
