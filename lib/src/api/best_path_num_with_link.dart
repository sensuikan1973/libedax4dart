import 'package:gviz/gviz.dart';
import 'package:meta/meta.dart';

import 'constants.dart';
import 'link.dart';
import 'util.dart';

@immutable
class BestPathNumWithLink {
  const BestPathNumWithLink(
    this.bestPathNumOfBlack,
    this.bestPathNumOfWhite,
    this.link,
    this.move,
    this.root,
  );

  /// best path num to win for current player.
  final int bestPathNumOfBlack;

  /// best path num to win for opponent player.
  final int bestPathNumOfWhite;

  /// link.
  final Link link;

  /// played square.
  final int move;

  /// e.g. `f5`
  String get moveString => move2String(move);

  final BestPathNumNode root;
}

/// Node value of best path num Tree
class BestPathNumNode {
  BestPathNumNode(this.parent, this.value);
  final BestPathNumNodeValue value;
  final BestPathNumNode? parent;
  final List<BestPathNumNode> children = [];

  Map<String, String> _graphvizNodeProperties(final BestPathNumNode node) => {
        'style': 'filled',
        'fillcolor': node.value.currentColor == TurnColor.black ? 'grey' : 'white',
        'shape': 'record',
        'label':
            '{ ${node.value.moves} | { B: ${node.value.bestPathNumOfBlack} | W: ${node.value.bestPathNumOfWhite} } }',
      };

  /// Export the [dot file](http://www.graphviz.org/doc/info/lang.html) of [GrapViz](http://www.graphviz.org/) as this node is regarded as root.
  String exportGraphvizDotFile() {
    final gviz = Gviz()..addNode(value.moves, properties: _graphvizNodeProperties(this)); // regarde myself root.
    _buildGraphviz(this, gviz);
    return gviz.toString();
  }

  void _buildGraphviz(final BestPathNumNode parent, final Gviz gviz) {
    for (final node in parent.children) {
      gviz
        ..addNode(node.value.moves, properties: _graphvizNodeProperties(node))
        ..addEdge(parent.value.moves, node.value.moves);
      _buildGraphviz(node, gviz);
    }
  }
}

/// Node of best path num Tree
class BestPathNumNodeValue {
  BestPathNumNodeValue(this.moves, this.currentColor) {
    if (currentColor == TurnColor.black) {
      bestPathNumOfWhite = 0;
      bestPathNumOfBlack = _upperInfinity;
    } else {
      bestPathNumOfBlack = 0;
      bestPathNumOfWhite = _upperInfinity;
    }
  }
  late int bestPathNumOfBlack;
  late int bestPathNumOfWhite;
  final String moves;
  final int currentColor;

  static const _upperInfinity = 10000;
}
