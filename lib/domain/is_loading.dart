class IsLoading {
  bool isLoading = false;

  bool startLoading() {
    return isLoading = true;
  }

  bool endLoading() {
    return isLoading = false;
  }
}
