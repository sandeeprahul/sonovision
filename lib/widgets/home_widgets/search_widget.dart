import 'package:flutter/material.dart';

class AnimatedSearchBar extends StatefulWidget {
  final Map<String, dynamic> style;

  const AnimatedSearchBar({super.key, required this.style});

  @override
  State<AnimatedSearchBar> createState() => _AnimatedSearchBarState();
}

class _AnimatedSearchBarState extends State<AnimatedSearchBar>
    with SingleTickerProviderStateMixin {
  late FocusNode _focusNode;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  void _handleFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
    _isFocused ? _controller.forward() : _controller.reverse();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 2.0, right: 2.0,),

            child: Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 2.0, left: 2.0, right: 2.0),
              child: Row(
                children: [
                  // Search Box Material
                  Expanded(
                    child: Material(
                      elevation: _isFocused ? 12 : 6,
                      shadowColor: Theme.of(context).shadowColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        height: style['height']?.toDouble() ?? 56.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              style['borderRadius']?.toDouble() ?? 16.0),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 16),
                            Icon(Icons.search_rounded, color: Colors.black),
                            // Icon(Icons.search_rounded, color: Theme.of(context).iconTheme.color),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                style['placeholder'] ?? 'Search...',
                                style: TextStyle(
                                  color: Theme.of(context).textTheme.bodyLarge?.color,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Camera Icon Material
                  Material(
                    elevation: 6,
                    shadowColor: Theme.of(context).shadowColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(24),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () {
                        // Handle camera tap
                      },
                      child:   Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.6),
                              Colors.black.withOpacity(0.2),
                            ],
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.transparent,
                          child: ClipOval(
                              child:Icon(Icons.camera_alt_rounded,size: 20,) /*Image.network(
                            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=2576&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                            width: 42,
                            height: 42,
                            fit: BoxFit.cover,
                          ),*/
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
          SizedBox(height: 22,),
        ],
      ),
    );
  }

}

//
// class SearchWidget extends StatelessWidget {
//   final Map<String, dynamic> style;
//
//   const SearchWidget({super.key, required this.style});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: style['height']?.toDouble() ?? 56,
//       margin: EdgeInsets.all(style['margin']?.toDouble() ?? 16),
//       decoration: BoxDecoration(
//         color: Colors.grey[100],
//         borderRadius: BorderRadius.circular(style['borderRadius']?.toDouble() ?? 12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(style['borderRadius']?.toDouble() ?? 12),
//           onTap: () {
//             // Navigate to search screen
//           },
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Row(
//               children: [
//                 Icon(
//                   Icons.search,
//                   color: Colors.grey[600],
//                   size: 24,
//                 ),
//                 const SizedBox(width: 12),
//                 Text(
//                   style['placeholder'] ?? 'Search products...',
//                   style: TextStyle(
//                     color: Colors.grey[600],
//                     fontSize: 16,
//                   ),
//                 ),
//                 const Spacer(),
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[200],
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Icon(
//                     Icons.tune,
//                     color: Colors.grey[700],
//                     size: 20,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
