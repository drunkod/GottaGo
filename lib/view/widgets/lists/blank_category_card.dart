import 'package:flutter/material.dart';
import 'package:leggo/view/widgets/lists/create_list_dialog.dart';

class BlankCategoryCard extends StatelessWidget {
  const BlankCategoryCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 4.0),
      child: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 1.618,
                //color: FlexColor.materialDarkPrimaryContainerHc,
                child: ListTile(
                  minVerticalPadding: 30.0,
                  onTap: () async {
                    //context.read<SavedPlacesBloc>().add(LoadPlaces());
                    // context.go('/placeList-page');
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return const CreateListDialog();
                      },
                    );
                  },
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 24.0),
                  minLeadingWidth: 20,

                  //tileColor: categoryColor,
                  title: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 10.0,
                        children: [
                          const Icon(
                            Icons.post_add_rounded,
                            size: 24,
                          ),
                          Text(
                            'Create a List',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // subtitle: const Padding(
                  //   padding: EdgeInsets.only(left: 24.0),
                  //   child: Text('0 Saved Places'),
                  // ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
