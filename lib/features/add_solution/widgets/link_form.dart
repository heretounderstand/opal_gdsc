import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:opale/theme/pallete.dart';

class LinkForm extends StatefulWidget {
  final ValueChanged<String> link;
  final int color;
  final String li;
  const LinkForm(
      {Key? key, required this.link, required this.color, this.li = ''})
      : super(key: key);

  @override
  State<LinkForm> createState() => _LinkFormState();
}

class _LinkFormState extends State<LinkForm> {
  bool isSet = false;
  final TextEditingController _linkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _linkController.text = widget.li;
  }

  @override
  void dispose() {
    super.dispose();
    _linkController.dispose();
  }

  bool check(String l) {
    bool isUrlValid = AnyLinkPreview.isValidLink(
      l,
    );
    if (isUrlValid) {
      widget.link(l);
    }
    return isUrlValid;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: width * 0.7,
                child: TextField(
                  keyboardType: TextInputType.url,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  controller: _linkController,
                  decoration: const InputDecoration(
                    hintText: "Add a Link",
                    border: InputBorder.none,
                  ),
                  minLines: 1,
                  maxLines: 5,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isSet = (check(_linkController.text));
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(widget.color),
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Pallete.whiteColor,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 18),
          _linkController.text.isEmpty
              ? Container()
              : isSet
                  ? AnyLinkPreview(
                      link: _linkController.text,
                      errorBody: 'Please check if your link is correct',
                      errorTitle: 'An error occured',
                    )
                  : Text(
                      'Please enter a valid link',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(widget.color),
                      ),
                    ),
        ],
      ),
    );
  }
}
