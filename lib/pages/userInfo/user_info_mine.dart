import 'package:bot_toast/bot_toast.dart';
import 'package:cry/cry_image_upload.dart';
import 'package:cry/form/cry_input.dart';
import 'package:cry/form/cry_select.dart';
import 'package:cry/form/cry_select_date.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin/api/file_api.dart';
import 'package:flutter_admin/api/user_info_api.dart';
import 'package:cry/cry_button.dart';
import 'package:flutter_admin/constants/constant_dict.dart';
import 'package:cry/model/response_body_api.dart';
import 'package:flutter_admin/models/user_info.dart';
import 'package:flutter_admin/utils/adaptive_util.dart';
import 'package:flutter_admin/utils/dict_util.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart' as Path;
import 'package:http_parser/http_parser.dart';

import '../../generated/l10n.dart';

class UserInfoMine extends StatefulWidget {
  UserInfoMine();

  @override
  _UserInfoMineState createState() => _UserInfoMineState();
}

class _UserInfoMineState extends State<UserInfoMine> {
  UserInfo userInfo = UserInfo();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    UserInfoApi.getCurrentUserInfo().then((res) {
      this.userInfo = UserInfo.fromMap(res.data);
      this.setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget avatar = SizedBox(
      child: CryImageUpload(
        updateAreaSize: 200,
        updateAreaDefault: Icon(Icons.person, size: 200),
        fileList: [this.userInfo?.avatarUrl],
        onUpload: (imageBytes) {
          String filename = "test.png"; //todo
          String mimeType = mime(Path.basename(filename));
          var mediaType = MediaType.parse(mimeType);
          MultipartFile file = MultipartFile.fromBytes(imageBytes, contentType: mediaType, filename: filename);
          FormData formData = FormData.fromMap({"file": file});
          FileApi.upload(formData).then((res) {
            this.userInfo.avatarUrl = res.data;
            setState(() {});
          });
        },
      ),
    );
    List<Widget> propList = <Widget>[
      CryInput(
        label: S.of(context).personName,
        value: userInfo.name,
        onSaved: (v) => {userInfo.name = v},
        validator: (v) => v.isEmpty ? '必填' : null,
      ),
      CryInput(
        label: S.of(context).personNickname,
        value: userInfo.nickName,
        onSaved: (v) => {userInfo.nickName = v},
      ),
      CrySelectDate(
        context,
        label: S.of(context).personBirthday,
        value: userInfo.birthday,
        onSaved: (v) => {userInfo.birthday = v},
      ),
      CrySelect(
        label: S.of(context).personGender,
        dataList: DictUtil.getDictSelectOptionList(ConstantDict.CODE_GENDER),
        value: userInfo.gender,
        onSaved: (v) => {userInfo.gender = v},
      ),
      CrySelect(
        label: S.of(context).personDepartment,
        dataList: DictUtil.getDictSelectOptionList(ConstantDict.CODE_DEPT),
        value: userInfo.deptId,
        onSaved: (v) => {userInfo.deptId = v},
      ),
//       CryInput(label: '籍贯'),
    ];
    var form = _getForm(avatar, propList);
    var buttonBar = ButtonBar(
      alignment: MainAxisAlignment.start,
      children: <Widget>[
        CryButton(
          label: S.of(context).save,
          onPressed: () {
            FormState form = formKey.currentState;
            if (!form.validate()) {
              return;
            }
            form.save();
            UserInfoApi.saveOrUpdate(this.userInfo.toMap()).then((ResponseBodyApi res) {
              if (!res.success) {
                return;
              }
              BotToast.showText(text: S.of(context).saved);
            });
          },
          iconData: Icons.save,
        ),
      ],
    );
    var result = Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10),
          buttonBar,
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(10.0),
              children: <Widget>[form],
            ),
          ),
        ],
      ),
    );
    return result;
  }

  _getForm(Widget avatar, List<Widget> propList) {
    var form;
    if (isDisplayDesktop(context)) {
      propList = propList
          .map((e) => Expanded(
                child: e,
              ))
          .toList();
      form = Form(
        key: formKey,
        child: Row(
          children: [
            avatar,
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      propList[0],
                      propList[1],
                    ],
                  ),
                  Row(
                    children: [
                      propList[2],
                      propList[3],
                    ],
                  ),
                  Row(
                    children: [
                      propList[4],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      form = Form(
        key: formKey,
        child: Column(children: [avatar] + propList),
      );
    }
    return form;
  }
}
