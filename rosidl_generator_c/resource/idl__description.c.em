// generated from rosidl_generator_c/resource/idl__description.c.em
// with input from @(package_name):@(interface_path)
// generated code does not contain a copyright notice
@
@#######################################################################
@# EmPy template for generating <idl>__description.c files
@#
@# Context:
@#  - package_name (string)
@#  - interface_path (Path relative to the directory named after the package)
@#  - content (IdlContent, list of elements, e.g. Messages or Services)
@#  - type_description_info (HashedTypeDescription.schema.json dict)
@#######################################################################
@{
from rosidl_generator_c import escape_string
from rosidl_generator_type_description import extract_subinterface
from rosidl_generator_type_description import FIELD_TYPE_ID_TO_NAME
from rosidl_generator_type_description import GET_DESCRIPTION_FUNC
from rosidl_generator_type_description import GET_SOURCES_FUNC
from rosidl_parser.definition import Action
from rosidl_parser.definition import Service
from rosidl_pycommon import convert_camel_case_to_lower_case_underscore

type_description_msg = type_description_info['type_description_msg']
all_type_descriptions = [type_description_msg['type_description']] + type_description_msg['referenced_type_descriptions']

include_parts = [package_name] + list(interface_path.parents[0].parts) + [
    'detail', convert_camel_case_to_lower_case_underscore(interface_path.stem)]
include_base = '/'.join(include_parts)

full_type_descriptions = [type_description_msg]
for service in content.get_elements_of_type(Service):
  full_type_descriptions.append(extract_subinterface(type_description_msg, 'request_message'))
  full_type_descriptions.append(extract_subinterface(type_description_msg, 'response_message'))
  full_type_descriptions.append(extract_subinterface(type_description_msg, 'event_message'))
for action in content.get_elements_of_type(Action):
  full_type_descriptions.append(extract_subinterface(type_description_msg, 'goal'))
  full_type_descriptions.append(extract_subinterface(type_description_msg, 'result'))
  full_type_descriptions.append(extract_subinterface(type_description_msg, 'feedback'))

  send_goal_service = extract_subinterface(type_description_msg, 'send_goal_service')
  full_type_descriptions.append(send_goal_service)
  full_type_descriptions.append(extract_subinterface(send_goal_service, 'request_message'))
  full_type_descriptions.append(extract_subinterface(send_goal_service, 'response_message'))
  full_type_descriptions.append(extract_subinterface(send_goal_service, 'event_message'))

  get_result_service = extract_subinterface(type_description_msg, 'get_result_service')
  full_type_descriptions.append(get_result_service)
  full_type_descriptions.append(extract_subinterface(get_result_service, 'request_message'))
  full_type_descriptions.append(extract_subinterface(get_result_service, 'response_message'))
  full_type_descriptions.append(extract_subinterface(get_result_service, 'event_message'))

  full_type_descriptions.append(extract_subinterface(type_description_msg, 'feedback_message'))

def typename_to_c(typename):
  return typename.replace('/', '__')

def static_seq(varname, values):
  """Statically define a runtime Sequence or String type."""
  if values:
    return f'{{{varname}, {len(values)}, {len(values)}}}'
  return '{NULL, 0, 0}'
}@

#include "@(include_base)__functions.h"

// Declare and define all type names, field names, and default values
@[for itype_description in all_type_descriptions]@
@{
td_c_typename = typename_to_c(itype_description['type_name'])
}@
static char @(td_c_typename)__TYPE_NAME[] = "@(itype_description['type_name'])";
@[  for field in itype_description['fields']]@
static char @(td_c_typename)__FIELD_NAME__@(field['name'])[] = "@(field['name'])";
@[    if field['default_value']]@
static char @(td_c_typename)__DEFAULT_VALUE__@(field['name'])[] = "@(escape_string(field['default_value']))";
@[    end if]@
@[  end for]@

@[end for]@
@
/// Define all arrays of Fields
@[for itype_description in all_type_descriptions]@
@{
td_c_typename = typename_to_c(itype_description['type_name'])
}@

@[  if itype_description['fields']]@
static rosidl_runtime_c__type_description__Field @(td_c_typename)__FIELDS[] = {
@[    for field in itype_description['fields']]@
  {
    @(static_seq(f"{td_c_typename}__FIELD_NAME__{field['name']}", field['name'])),
    {
      rosidl_runtime_c__type_description__FieldType__@(FIELD_TYPE_ID_TO_NAME[field['type']['type_id']]),
      @(field['type']['capacity']),
      @(field['type']['string_capacity']),
      @(static_seq(f"{typename_to_c(field['type']['nested_type_name'])}__TYPE_NAME", field['type']['nested_type_name'])),
    },
    @(static_seq(f"{td_c_typename}__DEFAULT_VALUE__{field['name']}", field['default_value'])),
  },
@[    end for]@
};
@[  end if]@
@[end for]@

/// Define exported TypeDescriptions and TypeSources
@[for msg in full_type_descriptions]@
@{
td_typename = msg['type_description']['type_name']
td_c_typename = typename_to_c(td_typename)
ref_tds = msg['referenced_type_descriptions']
}@

@[  if ref_tds]@
static rosidl_runtime_c__type_description__IndividualTypeDescription @(td_c_typename)__REFERENCED_TYPE_DESCRIPTIONS[] = {
@[    for ref_td in ref_tds]@
  {
    @(static_seq(f"{typename_to_c(ref_td['type_name'])}__TYPE_NAME", ref_td['type_name'])),
    @(static_seq(f"{typename_to_c(ref_td['type_name'])}__FIELDS", ref_td['fields'])),
  },
@[    end for]@
};
@[  end if]@

const rosidl_runtime_c__type_description__TypeDescription *
@(td_c_typename)__@(GET_DESCRIPTION_FUNC)()
{
  static const rosidl_runtime_c__type_description__TypeDescription description = {
    {
      @(static_seq(f'{td_c_typename}__TYPE_NAME', td_typename)),
      @(static_seq(f'{td_c_typename}__FIELDS', msg['type_description']['fields'])),
    },
    @(static_seq(f'{td_c_typename}__REFERENCED_TYPE_DESCRIPTIONS', ref_tds)),
  };
  return &description;
}

const rosidl_runtime_c__type_description__TypeSource__Sequence *
@(td_c_typename)__@(GET_SOURCES_FUNC)()
{
@# TODO(emersonknapp) Implement raw source code embedding/generation. This sequence is left empty for now.
  static const rosidl_runtime_c__type_description__TypeSource__Sequence sources = @(static_seq(None, ''));
  return &sources;
}
@[end for]@
