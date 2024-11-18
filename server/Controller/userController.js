const User=require('../Model/User')

const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
// Create user (Signup)
exports.createUser = async (req, res) => {
    try {
      const { name, email, password } = req.body;
  
      // Check if user already exists
      const existingUser = await User.findOne({ email });
      if (existingUser) {
        return res.status(400).json({ error: "Email already in use" });
      }
  
      // Hash the password
      const hashedPassword = await bcrypt.hash(password, 10);
  
      // Create and save the user
      const user = new User({ name, email, password: hashedPassword });
      await user.save();
      res.status(201).json({ message: "User created successfully" });
    } catch (error) {
      res.status(400).json({ error: error.message });
    }
  };
  
  // Login user
  exports.loginUser = async (req, res) => {
    try {
      const { email, password } = req.body;
  
      // Find the user by email
      const user = await User.findOne({ email });
      if (!user) {
        return res.status(404).json({ error: "Invalid email or password" });
      }
  
      // Compare the password
      const isMatch = await bcrypt.compare(password, user.password);
      if (!isMatch) {
        return res.status(401).json({ error: "Invalid email or password" });
      }
  
      // Generate a JWT token
      const token = jwt.sign({ id: user._id }, "secretKey", { expiresIn: "1h" });
      res.status(200).json({ message: "Login successful", token });
    } catch (error) {
      res.status(400).json({ error: error.message });
    }
  };

exports.deleteUser = async(req,res)=>{
    const { userId } = req.params.id; 
    try {
        const user = await User.findByIdAndDelete(userId);
        if (!user) {
            return res.status(404).json({ error: 'User not found' });
        }
        res.status(200).json({ message: 'User deleted successfully' });
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
}

exports.getAllUsers = async (req, res) => {
    try {
        const users = await User.find();
        res.status(200).json(users);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};


exports.updateUser = async(req,res)=>{
    try {
        const { id } = req.params; 
        const update = req.body; 
    
        const result = await User.updateOne({ _id: id }, { $set: update });
        if (result.matchedCount === 0) {
          return res.status(404).json({ message: "User not found" });
    }
}
catch(error)
{
    res.status(400).json({error:error.message})
}
}


