#ifndef SHADERFUNCS_H
#define SHADERFUNCS_H

#define SHADER_MACRO 0;
#define SHADER_STRUCT 1;
#define SHADER_FUNCTION 2;

#define INPUT_INT 0;
#define INPUT_OPTION 1;

struct shader_input_int_spec {
  int *min;
  int *max;
  int *defaultvalue;
};

struct shader_input_option_spec {
  char **options;
  int *defaultvalue;
};

struct shader_input {
  char *id;
  int type;
  void *spec;
};

struct shader_parameter_value {
  char *value;
  int dependencycount;
  struct shader_function *dependencies;
};

struct shader_parameter {
  char *id;
  int valuecount;
  struct shader_parameter_value *values;
};

struct shader_function {
  char *id;
  int order;
  int type;
  char *code;
  int inputcount;
  struct shader_input *inputs;
  int parametercount;
  struct shader_parameter *parameters;
  int dependencycount;
  struct shader_function *dependencies;
};

struct shader_function *sf_init(struct shader_function *, char *id, int type, char *code);
struct shader_parameter *sp_init(struct shader_parameter *, char *id);
struct shader_parameter_value *sv_init(struct shader_parameter_value *, char *value);
struct shader_input *si_init(struct shader_input *, char *id, int type, void *spec);
struct shader_input_int_spec *st_init(struct shader_input_int_spec *, int *min, int *max, int *defaultvalue);
struct shader_input_option_spec *so_init(struct shader_input_option_spec *, int *defaultvalue);

void sf_add_input(struct shader_function *, struct shader_input *);
void sf_add_parameter(struct shader_function *, struct shader_parameter *);
void sf_add_dependency(struct shader_function *, struct shader_function *);

void sp_add_value(struct shader_parameter *, struct shader_parameter_value *);

void sv_add_dependency(struct shader_parameter_value *, struct shader_function *);

void so_add_option(struct shader_input_option_spec *, char *);

void init_archive(int capacity);
void increase_capacity(int newcapacity);
void add_function(struct shader_function *);
struct shader_function *get_function(char *id);

#endif
