import 'package:flutter/material.dart';
import 'package:lockie/blocs/codes_bloc/bloc.dart';
import 'package:lockie/models/code.dart';
import 'package:lockie/screens/constants.dart';

void showCodeEditBottomSheet(BuildContext ctx, Code code, CodesBloc codesBloc) {
  showModalBottomSheet(
      context: ctx,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(
                  Icons.edit,
                  color: kCommentColor,
                ),
                title: Text('Edit'),
                onTap: () async {
                  String newCodeName = await showEditNameDialog(context, code.name);
                  Navigator.of(context).pop();
                  if(newCodeName != null && newCodeName != code.name) {
                    codesBloc.add(CodeUpdated(code, code.copyWith(name: newCodeName)));
                  }
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                title: Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () async {
                  bool delete = await showDeleteDialog(context);
                  Navigator.of(context).pop();
                  if(delete) {
                    codesBloc.add(CodeDeleted(code));
                  }
                },
              ),
            ],
          ),
        );
      }
  );
}

Future<bool> showDeleteDialog(context) async {
  bool delete = false;

  Widget cancelButton = FlatButton(
    child: Text("Cancel"),
    onPressed:  () {
      delete = false;
      Navigator.of(context).pop();
    },
  );
  Widget kickButton = FlatButton(
    child: Text(
      "DELETE",
      style: TextStyle(
          color: Colors.red
      ),
    ),
    onPressed:  () {
      delete = true;
      Navigator.of(context).pop();
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text("Are you sure?"),
    content: Text("Do you really want to delete this code? This action cannot be reversed."),
    actions: [
      cancelButton,
      kickButton,
    ],
  );

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );

  return delete;
}

Future<String> showEditNameDialog(context, String initialVal) async {
  String name = initialVal;
  return await showDialog<String>(
    context: context,
    builder: (context) => new AlertDialog(
      contentPadding: const EdgeInsets.all(16.0),
      content: new Row(
        children: <Widget>[
          new Expanded(
            child: new TextField(
              autofocus: true,
              maxLength: 32,
              controller: TextEditingController(text: initialVal),
              decoration: kInputDecorationRev.copyWith(
                  labelText: 'Name',
                  hintText: 'eg. Namecheap Main Account',
              ),
              onChanged: (newValue) {
                name = newValue;
              },
            ),
          )
        ],
      ),
      actions: <Widget>[
        new FlatButton(
            child: const Text('CANCEL'),
            onPressed: () {
              Navigator.pop(context);
              return initialVal;
            }),
        new FlatButton(
            child: const Text('EDIT'),
            onPressed: () {
              Navigator.pop(context, name);
              return name;
            })
      ],
    ),
  );
}