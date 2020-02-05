function varassign(obj,var)
  nvarin = numel(var);
  assert(~mod(nvarin,2),'Field and value input arguments must come in pairs.');
  prop = properties(obj);
  for i = 1:2:nvarin-1
    idx = find(ismember(lower(prop),lower(var{i})));
    assert(~isempty(idx),'No public property pos exists for class %s.',class(obj));
    obj.(prop{idx}) = var{i+1};
  end
end