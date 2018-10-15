# coding=utf-8
import yaml
import codecs
import jinja2
import re


class ParserSwagger(object):
	_HTTP_VERBS = set(['get', 'put', 'post', 'delete', 'options', 'head', 'patch'])

	def __init__(self, swagger_path):
		try:
			arguments = {}
			with codecs.open(swagger_path, 'r', 'utf-8') as swagger_yaml:
				swagger_template = swagger_yaml.read()
				swagger_string = jinja2.Template(swagger_template).render(**arguments)
				self.specification = yaml.safe_load(swagger_string)
		except Exception as e:
			print ("__init__  Error :", e)

		# Run parsing
		self.basePath = self.specification.get('basePath', '')
		self.host = self.specification.get('host', '')
		self.tags = []
		self.build_tags()
		self.paths = self.specification.get('paths', {}).keys()
		self.definitions = self.specification.get('definitions', {}).keys()
		self.paths_data = {}
		self.build_paths_data()

	def build_tags(self):
		for tag_dict in self.specification.get('tags', []):
			tag = tag_dict.get("name", "")
			if tag:
				self.tags.append(tag)

	def build_paths_data(self):
		for path in self.paths:
			for mode in self.get_path_modes(path):
				self.paths_data.update({path: self._get_path_data(path,mode)})

	def get_tags_paths(self):
		tags_paths = {}
		for tag in self.tags:
			tags_paths.update({tag: []})

		for path in self.paths:
			tags = self.get_path_tags(path)
			for tag in tags:
				tags_paths[tag].append(path)
		for tag in self.tags:
			tags_paths[tag] = list(set(tags_paths[tag]))
		return tags_paths

	def get_path_tags(self, path):
		tags = []
		path_spec = self.specification.get("paths", {}).get(path, {})
		for value in path_spec.values():
			tags = tags + value['tags']
		return list(set(tags))

	def get_path_modes(self, path):
		path_spec = self.specification.get("paths", {}).get(path, {})
		for mode in path_spec.keys():
			if mode in self._HTTP_VERBS:
				pass
			else:
				print (mode," nameError")
		return path_spec.keys()

	def get_definition_data(self, def_name):
		if def_name in self.definitions:
			def_spec = self.specification.get('definitions', {}).get(def_name, {})
			if def_spec.get('type', 'object') == "object":
				return self._value_from_object(def_spec)
			else:
				print (def_name, " typeError")
		else:
			print (def_name, " nameError")

	def _get_path_data(self, path,mode):
		path_spec = self.specification.get("paths", {}).get(path, {})
		path_spec[mode]['responses'] = self._get_responses_data(path_spec[mode].get('responses', {}))
		path_spec[mode]['parameters'] = self._get_parameters_data(path_spec[mode].get('parameters', []))
		return path_spec

	def _get_parameters_data(self, parameters):
		resp = []
		for param in parameters:
			param_data = {'required': param.get('required', False), 'method': param['in']}
			if param['in'] == "body":
				value = self._value_parser(param['schema'])
			else:
				value = self._value_parser(param)
			param_data.update({"name": {param["name"]: value}})
			resp.append(param_data)
		return resp

	def _get_responses_data(self, responses):
		resp = {}
		for key, value in responses.items():
			resp.update({key: self._value_parser(value.get("schema", {}))})
		return resp

	def _value_parser(self, value):
		if '$ref' in value.keys():
			return self._value_from_definition(value)
		value_type = value.get("type", "object")
		if value_type == "object":
			return self._value_from_object(value)
		elif value_type == "array" and "items" in value.keys():
			return self._value_from_array(value)
		else:
			return self.get_basic_type(value_type)[0]

	def _value_from_definition(self, value):
		def_name = self.get_definition_name_from_ref(value['$ref'])
		def_spec = self.specification["definitions"][def_name]
		return self._value_parser(def_spec)

	def _value_from_object(self, value):
		resp = {}
		prop = value.get("properties", {})
		for prop_key, prop_value in prop.items():
			resp.update({prop_key: self._value_parser(prop_value)})
		return resp

	def _value_from_array(self, value):
		resp = []
		items = value.get("items", {})
		if "properties" in items.keys():
			prop_data = {}
			for prop_key, prop_value in items['properties'].items():
				prop_data.update({prop_key: self._value_parser(prop_value)})

			resp.append(prop_data)
		else:
			resp.append(self._value_parser(items))
		return resp

	@staticmethod
	def get_definition_name_from_ref(ref):
		p = re.compile('#\/definitions\/(.*)')
		definition_name = re.sub(p, r'\1', ref)
		return definition_name

	@staticmethod
	def get_basic_type(type):
		if type == 'integer':
			return [0, 24]
		elif type == 'number':
			return [1.0, 5.5]
		elif type == 'string':
			return ['string', 'string2']
		elif type == 'datetime':
			return ['2018-08-07', '2015-08-28T09:02:57.481Z']
		elif type == 'boolean':
			return [True, False]
		elif type == 'null':
			return ['null', 'null']


if __name__ == '__main__':
	from Conf.Properties import *
	#
	filename = os.path.join(curr_dir, "yaml", "exam-swagger.yaml")
	p = ParserSwagger(filename)
	print (p.paths_data['/users/phone'])
