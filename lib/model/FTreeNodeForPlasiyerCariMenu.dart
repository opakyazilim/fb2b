import 'package:b2b/const/Ctanim.dart';
import 'package:flutter/material.dart';

import 'cariVePlasiyerMenuModel.dart';

class FTreeNodeForPlasiyerCariMenu extends StatefulWidget {
  final CariVePlasiyerMenuModel data;
  final CariVePlasiyerMenuModel parent;

  final bool lazy;
  final Widget icon;
  final bool showCheckBox;
  final bool showActions;
  final double offsetLeft;

  final Function(CariVePlasiyerMenuModel node) onTap;
  final void Function(bool checked, CariVePlasiyerMenuModel node) onCheck;

  final void Function(CariVePlasiyerMenuModel node) onExpand;
  final void Function(CariVePlasiyerMenuModel node) onCollapse;

  final Future Function(CariVePlasiyerMenuModel node) load;
  final void Function(CariVePlasiyerMenuModel node) onLoad;

  final void Function(CariVePlasiyerMenuModel node) remove;
  final void Function(
      CariVePlasiyerMenuModel node, CariVePlasiyerMenuModel parent) onRemove;

  final void Function(CariVePlasiyerMenuModel node) append;
  final void Function(
      CariVePlasiyerMenuModel node, CariVePlasiyerMenuModel parent) onAppend;

  const FTreeNodeForPlasiyerCariMenu({
    Key? key,
    required this.data,
    required this.parent,
    required this.offsetLeft,
    required this.showCheckBox,
    required this.showActions,
    required this.icon,
    required this.lazy,
    required this.load,
    required this.append,
    required this.remove,
    required this.onTap,
    required this.onCheck,
    required this.onLoad,
    required this.onExpand,
    required this.onAppend,
    required this.onRemove,
    required this.onCollapse,
  }) : super(key: key);

  @override
  _FTreeNodeForPlasiyerCariMenuState createState() =>
      _FTreeNodeForPlasiyerCariMenuState();
}

class _FTreeNodeForPlasiyerCariMenuState
    extends State<FTreeNodeForPlasiyerCariMenu>
    with SingleTickerProviderStateMixin {
  bool _isExpaned = false;
  bool _isChecked = false;
  bool _showLoading = false;
  Color _bgColor = Colors.transparent;
  late AnimationController _rotationController;
  final Tween<double> _turnsTween = Tween<double>(begin: -0.25, end: 0.0);
  final Tween<double> _turnsTween2 = Tween<double>(begin: 0.0, end: 0.0);

  List<FTreeNodeForPlasiyerCariMenu> _geneFTreeNodeForPlasiyerCariMenus(
      List list) {
    return List.generate(list.length, (int index) {
      return FTreeNodeForPlasiyerCariMenu(
        data: list[index],
        parent: widget.data,
        remove: widget.remove,
        append: widget.append,
        icon: widget.icon,
        lazy: widget.lazy,
        load: widget.load,
        offsetLeft: widget.offsetLeft,
        showCheckBox: widget.showCheckBox,
        showActions: widget.showActions,
        onTap: widget.onTap,
        onCheck: widget.onCheck,
        onExpand: widget.onExpand,
        onLoad: widget.onLoad,
        onCollapse: widget.onCollapse,
        onRemove: widget.onRemove,
        onAppend: widget.onAppend,
      );
    });
  }

  @override
  initState() {
    super.initState();

    _isExpaned = false;

    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onExpand(widget.data);
        } else if (status == AnimationStatus.reverse) {
          widget.onCollapse(widget.data);
        }
      });
    if (_isExpaned) {
      _rotationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        MouseRegion(
          onHover: (event) {},
          onEnter: (event) {
            _bgColor = Colors.grey[200]!;
            setState(() {});
          },
          onExit: (event) {
            _bgColor = Colors.transparent;
            setState(() {});
          },
          child: GestureDetector(
            onTap: () {
              widget.onTap(widget.data);
            },
            child: Container(
              color: _bgColor,
              margin: const EdgeInsets.only(bottom: 2.0),
              padding: const EdgeInsets.only(right: 12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RotationTransition(
                    child: IconButton(
                      iconSize: 16,
                      icon: widget.data.AltMenuler.isEmpty
                          ? Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.025,
                              child: VerticalDivider(
                                thickness: 3,
                                color: Ctanim.secilKategoriID != widget.data.id
                                    ? Colors.grey
                                    : Colors.blue,
                              ))
                          : widget.icon,
                      onPressed: () {
                        // widget.onTap(widget.data);

                        if (widget.lazy && widget.data.AltMenuler.isEmpty) {
                          setState(() {
                            _showLoading = true;
                          });
                          widget.load(widget.data).then((value) {
                            if (value) {
                              _isExpaned = true;
                              _rotationController.forward();
                              widget.onLoad(widget.data);
                            }
                            _showLoading = false;
                            setState(() {});
                          });
                        } else {
                          _isExpaned = !_isExpaned;
                          if (_isExpaned) {
                            _rotationController.forward();
                          } else {
                            _rotationController.reverse();
                          }
                          setState(() {});
                        }
                      },
                    ),
                    turns: widget.data.AltMenuler.isNotEmpty
                        ? _turnsTween.animate(_rotationController)
                        : _turnsTween2.animate(_rotationController),
                  ),
                  if (widget.showCheckBox)
                    Checkbox(
                      value: _isChecked,
                      onChanged: (bool? value) {
                        _isChecked = value!;
                        widget.onCheck(_isChecked, widget.data);
                        setState(() {});
                      },
                    ),
                  if (widget.lazy && _showLoading)
                    const SizedBox(
                      width: 12.0,
                      height: 12.0,
                      child: CircularProgressIndicator(strokeWidth: 1.0),
                    ),
                  widget.data.url != ""
                      ? Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 6.0),
                            child: Text(
                              widget.data.adi!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.03,
                                color: Ctanim.secilKategoriID == widget.data.id
                                    ? Colors.blue
                                    : Colors.black,
                              ),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            print("BURADA");
                            if (widget.lazy && widget.data.AltMenuler.isEmpty) {
                              setState(() {
                                _showLoading = true;
                              });
                              widget.load(widget.data).then((value) {
                                if (value) {
                                  _isExpaned = true;
                                  _rotationController.forward();
                                  widget.onLoad(widget.data);
                                }
                                _showLoading = false;
                                setState(() {});
                              });
                            } else {
                              _isExpaned = !_isExpaned;
                              if (_isExpaned) {
                                _rotationController.forward();
                              } else {
                                _rotationController.reverse();
                              }
                              setState(() {});
                            }
                          },
                          child: Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6.0),
                              child: Text(
                                widget.data.adi!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.03,
                                  color:
                                      Ctanim.secilKategoriID == widget.data.id
                                          ? Colors.blue
                                          : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                  if (widget.showActions)
                    TextButton(
                      onPressed: () {
                        widget.append(widget.data);
                        widget.onAppend(widget.data, widget.parent);
                      },
                      child:
                          const Text('Add', style: TextStyle(fontSize: 12.0)),
                    ),
                  if (widget.showActions)
                    TextButton(
                      onPressed: () {
                        widget.remove(widget.data);
                        widget.onRemove(widget.data, widget.parent);
                      },
                      child: const Text('Remove',
                          style: TextStyle(fontSize: 12.0)),
                    ),
                ],
              ),
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: _rotationController,
          child: Padding(
            padding: EdgeInsets.only(left: widget.offsetLeft),
            child: Column(
                children:
                    _geneFTreeNodeForPlasiyerCariMenus(widget.data.AltMenuler)),
          ),
        )
      ],
    );
  }
}
