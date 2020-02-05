classdef Slider2 < handle
  properties
    ax
    pos
    wid
    lim
    val
    graph
    Enable 
  end
  properties (Dependent)
    axLim
    tick
  end
  properties (Hidden)
    Tick
    Gap
    BaseLine
    IntervalLine
    Marker
    Mouse
  end
  
  methods
    function obj = Slider2(ax,pos,wid,lim,val,varargin)
      obj.default();
      if ~nargin
        obj.ax = axes('Position',[0 0 1 1]);
        axis([0 560 0 420])
        axis 'off'
        hold on
        set(obj.ax.Parent,'WindowButtonMotionFcn',{@wbmfcn,obj},...
          'WindowButtonUpFcn',{@wbufcn,obj});
      else
        obj.ax = ax;
        obj.pos = pos;
        obj.wid = wid;
        obj.lim = lim;
        obj.val = val;
      end
      varassign(obj, varargin);
      %assignin(obj, varargin);
       obj.draw();
    end
    function default(obj)
      obj.pos.x = 100;
      obj.pos.y = 100;
      obj.wid = 150;
      obj.lim.m = 0;
      obj.lim.M = 100;
      obj.val.m = 25;
      obj.val.M = 75;
      obj.Enable = 'on';
      
      obj.Tick.M.ratio = 5;
      obj.Tick.m.ratio = 25;
      obj.Gap.tick.M = 10;
      obj.Gap.tick.m = 5;
      obj.Gap.tick_Line = 5;
      obj.Gap.tick_Label = 5;
      obj.Gap.mM_Marker = 10;
      obj.Gap.marker_Label = 20;
      obj.BaseLine.wid = 2;
      obj.BaseLine.color = ones(1,3)*0.5;
      obj.IntervalLine.wid = 3;
      obj.IntervalLine.color = 'r';
      obj.Marker.scale = 6;
      obj.Marker.x = [-1 -1 1 1 0 -1]'*obj.Marker.scale;
      obj.Marker.y = [0 1.5 1.5 0 -1 0]'*obj.Marker.scale;
      obj.Marker.color = ones(1,3)*0.9;
      obj.Mouse.click = [];
      obj.Mouse.x = [];
      obj.Mouse.y = [];
    end
    function axLim = get.axLim(obj)
      axLim.m = obj.pos.x;
      axLim.M = obj.pos.x + obj.wid;
    end
    function tick = get.tick(obj)
      M = linspace(obj.lim.m,obj.lim.M,obj.Tick.M.ratio); 
      m = setdiff(linspace(obj.lim.m,obj.lim.M,obj.Tick.m.ratio),M);
      tick.M = round(M);
      tick.m = round(m);
    end
    function draw(obj)
      hold(obj.ax,'on')
      %baseLine
      x = [obj.axLim.m;obj.axLim.M];
      y = [obj.pos.y;obj.pos.y];
      obj.graph.baseLine = line(x,y,'LineWidth',obj.BaseLine.wid,... 
        'Color',obj.BaseLine.color,'Parent',obj.ax);
      %intervalLine
      x = obj.label2axis([obj.val.m;obj.val.M]);
      y = [obj.pos.y;obj.pos.y];
      obj.graph.intervalLine = line(x,y,'LineWidth',obj.IntervalLine.wid,...
        'Color',obj.IntervalLine.color,'Parent',obj.ax,...
        'ButtonDownFcn',{@bdfcn,obj,'I'});
      
      %Tick
      x = obj.label2axis(obj.tick.M);
      y = [obj.pos.y; obj.pos.y - obj.Gap.tick.M] - obj.Gap.tick_Line;
      [tickX,tickY] = meshgrid(x,y);
      [labelX,labelY] = meshgrid(x,y(2) - obj.Gap.tick_Label);
      obj.graph.tick.M = line(tickX,tickY,'color','k','Linewidth',1,'Parent',obj.ax);
      obj.graph.label.tick.M = text(labelX,labelY,strsplit(num2str(obj.tick.M)),'color','k',...
        'HorizontalAlignment','center','VerticalAlignment','middle','Parent',obj.ax);
      
      x = obj.label2axis(obj.tick.m);
      y = [obj.pos.y; obj.pos.y - obj.Gap.tick.m] - obj.Gap.tick_Line;
      [x,y] = meshgrid(x,y);
      obj.graph.tick.m = line(x,y,'color','k','Linewidth',1,'Parent',obj.ax);
      %Marker
      x = obj.label2axis(obj.val.M) + obj.Marker.x;
      y = obj.pos.y + obj.Marker.y;
      obj.graph.marker.M = fill(x,y,obj.Marker.color,'Parent',obj.ax,...
        'ButtonDownFcn',{@bdfcn,obj,'M'});
      
      x = obj.label2axis(obj.val.m) + obj.Marker.x;
      y = obj.pos.y + obj.Marker.y;
      obj.graph.marker.m = fill(x,y,obj.Marker.color,'Parent',obj.ax,...
        'ButtonDownFcn',{@bdfcn,obj,'m'});
      %MarkerLabel
      x = obj.label2axis(obj.val.M);
      y = obj.pos.y + obj.Gap.marker_Label;
      obj.graph.marker.label.M = text(x,y,'Max','color','k','Parent',obj.ax,...
        'HorizontalAlignment','center','VerticalAlignment','middle');
      
      x = obj.label2axis(obj.val.m);
      y = obj.pos.y + obj.Gap.marker_Label;
      obj.graph.marker.label.m = text(x,y,'Min','color','k','Parent',obj.ax,...
        'HorizontalAlignment','center','VerticalAlignment','middle');
      
      
    end
    function Update(obj)
      x = obj.label2axis(obj.val.M) + obj.Marker.x;
      set(obj.graph.marker.M,'XData',x);
      
      x = obj.label2axis(obj.val.m) + obj.Marker.x;
      set(obj.graph.marker.m,'XData',x);
      
      x = obj.label2axis(obj.val.M);
      set(obj.graph.marker.label.M,'Position',[x obj.graph.marker.label.M.Position(2:end)]);
      
      x = obj.label2axis(obj.val.m);
      set(obj.graph.marker.label.m,'Position',[x obj.graph.marker.label.m.Position(2:end)]);
      
      x = obj.label2axis([obj.val.m;obj.val.M]);
      set(obj.graph.intervalLine,'XData',x);
    end
    function moveMarker(obj,lim,x)
      x = clamp(x,lim.m,lim.M);
      val = obj.axis2label(x);
      obj.val.(obj.Mouse.click) = val;
      obj.Update();
    end
    function moveInterval(obj,lim,x)
      x = clamp(x,lim.m,lim.M);
      obj.val.m = obj.axis2label(x - obj.Mouse.mDiff);
      obj.val.M = obj.axis2label(x + obj.Mouse.MDiff);
      obj.Update();
    end
    function axData = label2axis(obj,labelData)
      axData = linConvert(labelData,obj.lim.m,obj.lim.M,obj.axLim.m,obj.axLim.M);
    end    
    function labelData = axis2label(obj,axData)
      labelData = linConvert(axData,obj.axLim.m,obj.axLim.M,obj.lim.m,obj.lim.M);
    end
  end
end
function bdfcn(~,~,obj,who)
  if strcmp(obj.Enable,'off')
    return
  end
  obj.Mouse.click = who;
  pos = get(obj.ax,'CurrentPoint');
  obj.Mouse.x = pos(1,1);
  obj.Mouse.y = pos(1,2);
  obj.Mouse.mDiff = obj.Mouse.x - obj.label2axis(obj.val.m);
  obj.Mouse.MDiff = obj.label2axis(obj.val.M) - obj.Mouse.x;
end
function wbmfcn(~,~,obj)
  if isempty(obj.Mouse.click); return; end
  pos = get(obj.ax,'CurrentPoint');
  x = pos(1,1);
  switch obj.Mouse.click
    case 'm'
      lim.M = obj.label2axis(obj.val.M) - obj.Gap.mM_Marker;
      lim.m = obj.axLim.m;
      obj.moveMarker(lim,x);
    case 'M'
      lim.M = obj.axLim.M;
      lim.m = obj.label2axis(obj.val.m) + obj.Gap.mM_Marker;
      obj.moveMarker(lim,x);
    case 'I'
      lim.M = obj.axLim.M - obj.Mouse.MDiff;
      lim.m = obj.axLim.m + obj.Mouse.mDiff;
      obj.moveInterval(lim,x);
  end
end
function wbufcn(~,~,obj)
  obj.Mouse.click = [];
end

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

function y = linConvert(x,xlo,xhi,ylo,yhi)
  %y = a*x + b
  %
  % xlo |---------| xhi
  %          ||
  % ylo |---------| yhi
  
  ab = [xlo 1;xhi 1] \ [ylo;yhi];
  a = ab(1);
  b = ab(2);
  y = a*x + b;
end

function val = clamp(val,m,M)
  val(val < m) = m;
  val(val > M) = M;
end

function [Lmax,maxLidx,maxRidx] = findLmax(ipt)
  Lmax = 0;
  maxLidx = 0;
  maxRidx = 0;
  L = 0;
  Lidx = 0;
  i = 1;
  while i <= length(ipt)
    if ipt(i)
      if L == 1
        Lidx = i;
      end
      L = L + 1;
    else
      if L >= Lmax
        Lmax = L;
        maxLidx = Lidx;
        maxRidx = i - 1;
      end
      L = 1;
    end
    i = i + 1;
  end
  Lmax = Lmax - 1;
end