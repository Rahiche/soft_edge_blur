// This code is adapted from:
// https://github.com/jonahwilliams/flutter_shaders/blob/main/lib/src/animated_sampler.dart

// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

typedef AnimatedSamplerBuilder = void Function(
  ui.Image image,
  Size size,
  Canvas canvas,
);

class AnimatedSampler extends StatelessWidget {
  const AnimatedSampler(this.builder, {required this.child, super.key});

  final AnimatedSamplerBuilder builder;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _SamplerBuilder(builder, enabled: true, child: child);
  }
}

class _SamplerBuilder extends SingleChildRenderObjectWidget {
  const _SamplerBuilder(
    this.builder, {
    super.child,
    required this.enabled,
  });

  final AnimatedSamplerBuilder builder;
  final bool enabled;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderAnimatedSamplerWidget(
      devicePixelRatio: MediaQuery.of(context).devicePixelRatio,
      builder: builder,
      enabled: enabled,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderObject renderObject) {
    (renderObject as _RenderAnimatedSamplerWidget)
      ..devicePixelRatio = MediaQuery.of(context).devicePixelRatio
      ..builder = builder
      ..enabled = enabled;
  }
}

class _RenderAnimatedSamplerWidget extends RenderProxyBox {
  _RenderAnimatedSamplerWidget({
    required double devicePixelRatio,
    required AnimatedSamplerBuilder builder,
    required bool enabled,
  })  : _devicePixelRatio = devicePixelRatio,
        _builder = builder,
        _enabled = enabled;

  @override
  OffsetLayer updateCompositedLayer(
      {required covariant _SamplerBuilderLayer? oldLayer}) {
    final _SamplerBuilderLayer layer =
        oldLayer ?? _SamplerBuilderLayer(builder);
    layer
      ..callback = builder
      ..size = size
      ..devicePixelRatio = devicePixelRatio;
    return layer;
  }

  double get devicePixelRatio => _devicePixelRatio;
  double _devicePixelRatio;
  set devicePixelRatio(double value) {
    if (value == devicePixelRatio) {
      return;
    }
    _devicePixelRatio = value;
    markNeedsCompositedLayerUpdate();
  }

  AnimatedSamplerBuilder get builder => _builder;
  AnimatedSamplerBuilder _builder;
  set builder(AnimatedSamplerBuilder value) {
    if (value == builder) {
      return;
    }
    _builder = value;
    markNeedsCompositedLayerUpdate();
  }

  bool get enabled => _enabled;
  bool _enabled;
  set enabled(bool value) {
    if (value == enabled) {
      return;
    }
    _enabled = value;
    markNeedsPaint();
    markNeedsCompositingBitsUpdate();
  }

  @override
  bool get isRepaintBoundary => alwaysNeedsCompositing;

  @override
  bool get alwaysNeedsCompositing => enabled;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (size.isEmpty) {
      return;
    }
    assert(!_enabled || offset == Offset.zero);
    return super.paint(context, offset);
  }
}

class _SamplerBuilderLayer extends OffsetLayer {
  _SamplerBuilderLayer(this._callback);

  ui.Picture? _lastPicture;

  Size get size => _size;
  Size _size = Size.zero;
  set size(Size value) {
    if (value == size) {
      return;
    }
    _size = value;
    markNeedsAddToScene();
  }

  double get devicePixelRatio => _devicePixelRatio;
  double _devicePixelRatio = 1.0;
  set devicePixelRatio(double value) {
    if (value == devicePixelRatio) {
      return;
    }
    _devicePixelRatio = value;
    markNeedsAddToScene();
  }

  AnimatedSamplerBuilder get callback => _callback;
  AnimatedSamplerBuilder _callback;
  set callback(AnimatedSamplerBuilder value) {
    if (value == callback) {
      return;
    }
    _callback = value;
    markNeedsAddToScene();
  }

  ui.Image _buildChildScene(Rect bounds, double pixelRatio) {
    final ui.SceneBuilder builder = ui.SceneBuilder();
    final Matrix4 transform = Matrix4.diagonal3Values(
      pixelRatio,
      pixelRatio,
      1,
    );
    builder.pushTransform(transform.storage);
    addChildrenToScene(builder);
    builder.pop();
    return builder.build().toImageSync(
          (pixelRatio * bounds.width).ceil(),
          (pixelRatio * bounds.height).ceil(),
        );
  }

  @override
  void dispose() {
    _lastPicture?.dispose();
    super.dispose();
  }

  @override
  void addToScene(ui.SceneBuilder builder) {
    if (size.isEmpty) return;
    final ui.Image image = _buildChildScene(
      offset & size,
      devicePixelRatio,
    );
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    try {
      callback(image, size, canvas);
    } finally {
      image.dispose();
    }
    final ui.Picture picture = pictureRecorder.endRecording();
    _lastPicture?.dispose();
    _lastPicture = picture;
    builder.addPicture(offset, picture);
  }
}