import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:lockie/blocs/codes_bloc/bloc.dart';
import 'package:lockie/models/code.dart';
import 'package:lockie/screens/codes/code_bottom_sheet.dart';
import 'package:lockie/screens/codes/code_edit_bottom_sheet.dart';
import 'package:lockie/screens/constants.dart';

class CodesBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CodesBloc, CodesState>(
      builder: (context, state) {
        if(state is CodesLoadInProgress) {
          return Center(child: CircularProgressIndicator());
        } else if(state is CodesLoadFailure) {
          return Center(child: Text('Could not load codes :(', style: TextStyle(color: kCommentColor)));
        } else if(state is CodesLoadSuccess) {
          if(state.codes.length == 0) {
            return Center(
                child: Text(
                    'You don\'t have any codes.\nCreate one!',
                    style: TextStyle(color: kCommentColor),
                    textAlign: TextAlign.center
                ),
            );
          }

          CodesBloc codesBloc = BlocProvider.of<CodesBloc>(context);
          List<Code> codes = state.codes;
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ListView.builder(
              itemCount: codes.length,
              itemBuilder: (context, index) {
                return _codeTileBuilder(context, codes[index], codesBloc);
              },
            ),
          );
        }
        return Center(child: Text('WTF?!?', style: TextStyle(color: kCommentColor)));
      },
    );
  }

  Widget _codeTileBuilder(BuildContext context, Code code, CodesBloc codesBloc) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 0.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListTile(
            title: Text(code.name),
            contentPadding: EdgeInsets.fromLTRB(4.0, 2.0, 4.0, 2.0),
            leading: Container(
              width: 50,
              height: 50,
              child: code.storageUrl != null ? CachedNetworkImage(
                imageUrl: code.storageUrl,
                imageBuilder: (context, image) => Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: image,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                placeholder: (context, url) => ClipOval(
                  child: BlurHash(
                    hash: code.blurhash,
                    imageFit: BoxFit.contain,
                  ),
                ),
              ) : Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage("assets/images/default.png"),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            onTap: () {
              showCodeBottomSheet(context, code);
            },

            onLongPress: () {
              showCodeEditBottomSheet(context, code, codesBloc);
            },
          ),
        ),
      ),
    );
  }
}
