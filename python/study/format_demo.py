class User:
  def __init__(self, first_name, last_name):
    self.first_name = first_name
    self.last_name = last_name

  def __str__(self):
    return f"{self.first_name} {self.last_name}"

  def __repr__(self):
    return f"User name is{self.first_name} {self.last_name}"

user = User("zhang", "san")
print(f"{user}")
print(f"{user!r}")