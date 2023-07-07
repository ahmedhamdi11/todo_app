abstract class AppStates {}

class InitialState extends AppStates {}

// get data states
class GetDataSuccessState extends AppStates {}

class GetDataLoadingState extends AppStates {}

class GetDataErrorState extends AppStates {}

// insert data states
class InsertDataSuccessState extends AppStates {}

class InsertDataLoadingState extends AppStates {}

class InsertDataErrorState extends AppStates {}

// update data states
class UpdateDataSuccessState extends AppStates {}

class UpdateDataLoadingState extends AppStates {}

class UpdateDataErrorState extends AppStates {}

// delete data states
class DeleteDataSuccessState extends AppStates {}

class DeleteDataLoadingState extends AppStates {}

class DeleteDataErrorState extends AppStates {}

class CheckBoxChangedState extends AppStates {}
