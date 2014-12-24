package configuration

// RawEnvironment is the environment structure as it appear in the configuraiton
// file: fields are pointer because they are optionnal.
type RawEnvironment struct {
	Driver    *string
	Protocol  *string
	Host      *string
	Port      *uint64
	User      *string
	Password  *string
	Database  *string
	Directory *string
}