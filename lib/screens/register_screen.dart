import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameTextEditingController = TextEditingController();
  final emailTextEditingController = TextEditingController();
  final phoneTextEditingController = TextEditingController();
  final addressTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();
  final confirmTextEditingController = TextEditingController();

  bool _passwordVisible = false;

  //declare a GlobalKey
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: ListView(
          padding: EdgeInsets.all(0),
          children: [
            Column(
              children: [
                Image.asset(darkTheme ? 'images/city_dark.jpg' : 'images/city.jpg'),

                SizedBox(height: 20,),

                Text(
                    'Register',
                  style: TextStyle(
                    color: darkTheme ? Colors.amber.shade400 : Colors.indigo,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15,20,15,50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Form(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(50)
                              ],
                              decoration: InputDecoration(
                                hintText: 'Name: ',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                filled: true,
                                fillColor: darkTheme ? Colors.black45 : Colors.grey.shade200,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40),
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  )
                                ),
                                prefixIcon: Icon(Icons.person, color: darkTheme ? Colors.amber.shade400 : Colors.grey,)
                              ),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (text){
                                if(text==null||text.isEmpty){
                                  return 'Name can\'t be empty';
                                }
                                if(text.length < 2){
                                  return 'Please enter a valid name';
                                }
                                if(text.length > 49){
                                  return 'Name can\'t be more than 50';
                                }
                                return null;
                              },
                              onChanged: (text)=>setState(() {
                                nameTextEditingController.text = text;
                              }),
                            ),
                            SizedBox(height: 10,),
                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(100)
                              ],
                              decoration: InputDecoration(
                                  hintText: 'Email: ',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  filled: true,
                                  fillColor: darkTheme ? Colors.black45 : Colors.grey.shade200,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(40),
                                      borderSide: BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      )
                                  ),
                                  prefixIcon: Icon(Icons.person, color: darkTheme ? Colors.amber.shade400 : Colors.grey,)
                              ),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (text){
                                if(text==null||text.isEmpty){
                                  return 'Email can\'t be empty';
                                }
                                if(EmailValidator.validate(text) == true){
                                  return  null;
                                }
                                if(text.length < 2){
                                  return 'Please enter a valid email';
                                }
                                if(text.length > 49){
                                  return 'Email can\'t be more than 100';
                                }
                              },
                              onChanged: (text)=>setState(() {
                                emailTextEditingController.text = text;
                              }),
                            ),
                            SizedBox(height: 10,),
                            IntlPhoneField(
                              showCountryFlag: false,
                              dropdownIcon: Icon(
                                Icons.arrow_drop_down,
                                color: darkTheme ? Colors.amber.shade400 : Colors.grey,
                              ),
                              decoration: InputDecoration(
                                  hintText: 'Phone Number: ',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  filled: true,
                                  fillColor: darkTheme ? Colors.black45 : Colors.grey.shade200,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(40),
                                      borderSide: BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      )
                                  ),
                              ),
                              initialCountryCode: 'LK',
                              onChanged: (text)=>setState(() {
                                phoneTextEditingController.text = text.completeNumber;
                              }),
                            ),
                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(100)
                              ],
                              decoration: InputDecoration(
                                  hintText: 'Address: ',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  filled: true,
                                  fillColor: darkTheme ? Colors.black45 : Colors.grey.shade200,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(40),
                                      borderSide: BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      )
                                  ),
                                  prefixIcon: Icon(Icons.person, color: darkTheme ? Colors.amber.shade400 : Colors.grey,)
                              ),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (text){
                                if(text==null||text.isEmpty){
                                  return 'Address can\'t be empty';
                                }
                                if(text.length < 2){
                                  return 'Please enter a valid address';
                                }
                                if(text.length > 49){
                                  return 'Address can\'t be more than 100';
                                }
                                return null;
                              },
                              onChanged: (text)=>setState(() {
                                addressTextEditingController.text = text;
                              }),
                            ),
                            SizedBox(height: 20,),

                            TextFormField(
                              obscureText: !_passwordVisible,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(50)
                              ],
                              decoration: InputDecoration(
                                  hintText: 'Password: ',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  filled: true,
                                  fillColor: darkTheme ? Colors.black45 : Colors.grey.shade200,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(40),
                                      borderSide: BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      )
                                  ),
                                  prefixIcon: Icon(Icons.person, color: darkTheme ? Colors.amber.shade400 : Colors.grey,),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                      color: darkTheme ? Colors.amber.shade400 : Colors.grey,
                                    ),
                                    onPressed: (){
                                      // update the state i.e. toggle the state of passwordVisible variable
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                  )
                              ),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (text){
                                if(text==null||text.isEmpty){
                                  return 'Password can\'t be empty';
                                }
                                if(text.length < 6){
                                  return 'Please enter a valid password';
                                }
                                if(text.length > 49){
                                  return 'Password can\'t be more than 100';
                                }
                                return null;
                              },
                              onChanged: (text)=>setState(() {
                                passwordTextEditingController.text = text;
                              }),
                            ),
                            SizedBox(height: 20,),

                            TextFormField(
                              obscureText: !_passwordVisible,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(50)
                              ],
                              decoration: InputDecoration(
                                  hintText: 'Confirm Password: ',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  filled: true,
                                  fillColor: darkTheme ? Colors.black45 : Colors.grey.shade200,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(40),
                                      borderSide: BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      )
                                  ),
                                  prefixIcon: Icon(Icons.person, color: darkTheme ? Colors.amber.shade400 : Colors.grey,),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                      color: darkTheme ? Colors.amber.shade400 : Colors.grey,
                                    ),
                                    onPressed: (){
                                      // update the state i.e. toggle the state of passwordVisible variable
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                  )
                              ),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (text){
                                if(text==null||text.isEmpty){
                                  return 'Confirm Password can\'t be empty';
                                }
                                if(text != passwordTextEditingController.text){
                                  return 'Password do not match';
                                }
                                if(text.length < 6){
                                  return 'Please enter a valid password';
                                }
                                if(text.length > 49){
                                  return 'Password can\'t be more than 100';
                                }
                                return null;
                              },
                              onChanged: (text)=>setState(() {
                                passwordTextEditingController.text = text;
                              }),
                            ),
                            SizedBox(height: 20,),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: darkTheme ? Colors.black : Colors.white,
                                backgroundColor: darkTheme ? Colors.amber.shade400 : Colors.blue,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                minimumSize: Size(double.infinity, 50),
                              ),
                                onPressed: () {},
                                child: Text(
                                  'Register',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                )
                            ),
                            SizedBox(height: 20,),
                            GestureDetector(
                              onTap: () {},
                              child: Text(
                                'Forgot Password',
                                style: TextStyle(
                                  color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
