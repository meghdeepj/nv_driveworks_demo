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


#include <sm1/SSMMappings.hpp>

namespace SystemStateManager
{
namespace SM1
{


std::ostream& operator<<(std::ostream& out, const SSMStates state_enum)
{
    return out << SSM_enumToStr(state_enum);
}

const char* SSM_enumToStr(SSMStates e)
{
    switch(e)
    {
        case SSMStates::Degrade: return SSM_SSM_Degrade_str;
        case SSMStates::NormalOperation: return SSM_SSM_NormalOperation_str;
        case SSMStates::Standby: return SSM_SSM_Standby_str;
        case SSMStates::UrgentOperation: return SSM_SSM_UrgentOperation_str;
    }
    return "NULL_STATE";
}


SSMStates SSM_strToEnum(std::string state)
{
    static FixedMap<std::string, SSMStates> stringToState
    {
        {SSM_SSM_Degrade_str, SSMStates::Degrade},
        {SSM_SSM_NormalOperation_str, SSMStates::NormalOperation},
        {SSM_SSM_Standby_str, SSMStates::Standby},
        {SSM_SSM_UrgentOperation_str, SSMStates::UrgentOperation},
    };

    auto it = stringToState.find(state);
    if(it != stringToState.end())
    {
        return it->second;
    }
    return SSMStates::NULL_STATE;
}

SSMStates get_SSMState(SMBaseClass *obj)
{
    return SSM_strToEnum(obj->getCurrentState(SSM_SSM_str));
}


const char* SmEnumToStr(StateMachines e)
{
    switch(e)
    {
        case StateMachines::SSM: return SSM_SSM_str;
    }
    return "";
}

StateMachines getSmEnum(std::string sm)
{
    static FixedMap<std::string, StateMachines> sm_string_to_enum_map = 
    {
        {SSM_SSM_str, StateMachines::SSM},
    };

    auto it = sm_string_to_enum_map.find(sm);
    if(it != sm_string_to_enum_map.end())
    {
        return it->second;
    }
    return StateMachines::INVALID_STATEMACHINE;
}


}
}
